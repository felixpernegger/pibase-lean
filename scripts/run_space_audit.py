#!/usr/bin/env python3
"""Run or load the Lean-native space audit without inspecting Lean sources."""

from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Any, NoReturn

SCHEMA_VERSION = 1
CATALOG_SCHEMA_VERSION = 1
ALLOWED_STATUSES = frozenset({"implemented", "not-implemented", "invalid"})
TRUSTED_AXIOMS = frozenset({"Classical.choice", "Quot.sound", "propext"})
# Mirrors the schema-v1 conditional axiom mappings in the Lean report producer.
CONDITIONAL_AXIOM_ASSUMPTIONS: dict[str, str] = {}
# This independent web-side lock makes any change to the published Lean audit
# scope explicit in both implementations and their regression tests.
REQUIRED_SPACE_AUDIT_SCOPE = (
    "S000001",
    "S000004",
    "S000010",
    "S000189",
)
_HASH_RE = re.compile(r"[0-9a-f]{64}")
_SPACE_ID_RE = re.compile(r"S[0-9]{6}")
_PROPERTY_ID_RE = re.compile(r"P[0-9]{6}")
_MISSING = object()


class AuditAdapterError(Exception):
    """Base class for adapter failures."""


class AuditOutputError(AuditAdapterError):
    """Raised when an audit source does not contain a JSON object."""


class AuditReportValidationError(AuditAdapterError):
    """Raised when parsed JSON does not satisfy the audit schema."""


class AuditUnsuccessfulError(AuditAdapterError):
    """Raised when a valid report or its producing process was unsuccessful."""

    def __init__(self, result: AuditResult) -> None:
        self.result = result
        reasons = []
        if result.process_succeeded is False:
            reasons.append(f"spaceAudit exited with status {result.returncode}")
        if not result.report_succeeded:
            reasons.append("the audit report is unsuccessful")
        super().__init__("; ".join(reasons))


@dataclass(frozen=True)
class AuditResult:
    """A validated report together with independent process outcome details."""

    report: dict[str, Any]
    returncode: int | None
    stdout: str
    stderr: str
    source: str

    @property
    def process_succeeded(self) -> bool | None:
        """Process success, or ``None`` when the report came from an artifact."""
        return None if self.returncode is None else self.returncode == 0

    @property
    def report_succeeded(self) -> bool:
        """Whether the validated report describes a fully implemented audit."""
        return report_is_successful(self.report)

    @property
    def succeeded(self) -> bool:
        """Whether both the available process result and the report succeeded."""
        return self.process_succeeded is not False and self.report_succeeded

    def require_success(self) -> AuditResult:
        """Return this result, or raise while retaining the parsed report."""
        if not self.succeeded:
            raise AuditUnsuccessfulError(self)
        return self


class _Validator:
    def fail(self, path: str, message: str) -> NoReturn:
        raise AuditReportValidationError(f"{path}: {message}")

    def field(self, value: dict[str, Any], name: str, path: str) -> Any:
        result = value.get(name, _MISSING)
        if result is _MISSING:
            self.fail(path, f"missing required field {name!r}")
        return result

    def object(self, value: Any, path: str) -> dict[str, Any]:
        if not isinstance(value, dict):
            self.fail(path, "expected an object")
        return value

    def array(self, value: Any, path: str) -> list[Any]:
        if not isinstance(value, list):
            self.fail(path, "expected an array")
        return value

    def string(self, value: Any, path: str, *, nonempty: bool = True) -> str:
        if not isinstance(value, str) or (nonempty and not value):
            qualifier = "a nonempty string" if nonempty else "a string"
            self.fail(path, f"expected {qualifier}")
        return value

    def optional_string(self, value: Any, path: str) -> str | None:
        if value is None:
            return None
        return self.string(value, path)

    def boolean(self, value: Any, path: str) -> bool:
        if not isinstance(value, bool):
            self.fail(path, "expected a boolean")
        return value

    def integer(self, value: Any, path: str) -> int:
        if isinstance(value, bool) or not isinstance(value, int) or value < 0:
            self.fail(path, "expected a nonnegative integer")
        return value

    def strings(self, value: Any, path: str, *, unique: bool = False) -> list[str]:
        items = self.array(value, path)
        result = [self.string(item, f"{path}[{index}]") for index, item in enumerate(items)]
        if unique and len(set(result)) != len(result):
            self.fail(path, "strings must be unique")
        return result

    def status(self, value: Any, path: str) -> str:
        status = self.string(value, path)
        if status not in ALLOWED_STATUSES:
            self.fail(path, f"unsupported status {status!r}")
        return status

    def failures(self, value: Any, path: str) -> list[dict[str, Any]]:
        failures = self.array(value, path)
        for index, failure_value in enumerate(failures):
            failure_path = f"{path}[{index}]"
            failure = self.object(failure_value, failure_path)
            self.string(self.field(failure, "code", failure_path), f"{failure_path}.code")
            self.string(self.field(failure, "message", failure_path), f"{failure_path}.message")
        return failures

    def assumptions(self, value: Any, path: str) -> dict[str, Any]:
        assumptions = self.object(value, path)
        values = {
            name: self.strings(
                self.field(assumptions, name, path), f"{path}.{name}", unique=True
            )
            for name in ("expected", "declared", "used")
        }
        valid = self.boolean(self.field(assumptions, "valid", path), f"{path}.valid")
        expected_valid = values["expected"] == values["declared"] == values["used"]
        if valid != expected_valid:
            self.fail(
                f"{path}.valid",
                "must equal whether expected, declared, and used are identical",
            )
        return assumptions

    def axioms(self, value: Any, path: str) -> dict[str, Any]:
        axioms = self.object(value, path)
        values = {
            name: self.strings(
                self.field(axioms, name, path), f"{path}.{name}", unique=True
            )
            for name in ("axioms", "trusted", "conditional", "forbidden")
        }
        expected = {
            "trusted": [
                name for name in values["axioms"] if name in TRUSTED_AXIOMS
            ],
            "conditional": [
                name
                for name in values["axioms"]
                if name in CONDITIONAL_AXIOM_ASSUMPTIONS
            ],
            "forbidden": [
                name
                for name in values["axioms"]
                if name not in TRUSTED_AXIOMS
                and name not in CONDITIONAL_AXIOM_ASSUMPTIONS
            ],
        }
        for name, expected_values in expected.items():
            if values[name] != expected_values:
                self.fail(
                    f"{path}.{name}",
                    "must exactly classify the axioms array; "
                    f"expected {expected_values!r}",
                )
        return values

    def dependency_metadata(
        self,
        assumptions: dict[str, Any],
        axioms: dict[str, Any],
        path: str,
    ) -> None:
        expected_used = [
            CONDITIONAL_AXIOM_ASSUMPTIONS[name] for name in axioms["conditional"]
        ]
        if assumptions["used"] != expected_used:
            self.fail(
                f"{path}.assumptions.used",
                "must equal the assumptions induced by conditional axioms; "
                f"expected {expected_used!r}",
            )

    def implemented_common(
        self,
        *,
        path: str,
        status: str,
        type_valid: bool,
        assumptions: dict[str, Any],
        axioms: dict[str, Any],
        failures: list[dict[str, Any]],
    ) -> None:
        if status != "implemented":
            return
        if failures:
            self.fail(path, "implemented entry cannot contain failures")
        if not type_valid:
            self.fail(path, "implemented entry must have a valid type")
        if not assumptions["valid"]:
            self.fail(path, "implemented entry must have valid assumptions")
        if axioms["forbidden"]:
            self.fail(path, "implemented entry cannot use forbidden axioms")

    def presentation(self, value: Any, path: str) -> str:
        presentation = self.object(value, path)
        carrier = self.optional_string(
            self.field(presentation, "carrier", path), f"{path}.carrier"
        )
        canonical = self.optional_string(
            self.field(presentation, "canonicalHomeomorph", path),
            f"{path}.canonicalHomeomorph",
        )
        type_valid = self.boolean(
            self.field(presentation, "typeValid", path), f"{path}.typeValid"
        )
        assumptions = self.assumptions(
            self.field(presentation, "assumptions", path), f"{path}.assumptions"
        )
        axioms = self.axioms(
            self.field(presentation, "axioms", path), f"{path}.axioms"
        )
        self.dependency_metadata(assumptions, axioms, path)
        failures = self.failures(
            self.field(presentation, "failures", path), f"{path}.failures"
        )
        status = self.status(self.field(presentation, "status", path), f"{path}.status")
        self.implemented_common(
            path=path,
            status=status,
            type_valid=type_valid,
            assumptions=assumptions,
            axioms=axioms,
            failures=failures,
        )
        if status == "implemented" and (carrier is None or canonical is None):
            self.fail(path, "implemented presentation requires both declarations")
        return status

    def trait(self, value: Any, path: str) -> str:
        trait = self.object(value, path)
        property_id = self.string(
            self.field(trait, "propertyId", path), f"{path}.propertyId"
        )
        if _PROPERTY_ID_RE.fullmatch(property_id) is None:
            self.fail(f"{path}.propertyId", "expected a canonical property ID")
        self.optional_string(self.field(trait, "name", path), f"{path}.name")
        expected = self.boolean(self.field(trait, "expected", path), f"{path}.expected")
        polarity = self.boolean(self.field(trait, "polarity", path), f"{path}.polarity")
        certificate = self.optional_string(
            self.field(trait, "certificate", path), f"{path}.certificate"
        )
        provenance = self.field(trait, "provenance", path)
        if provenance is not None and provenance not in ("direct", "derived"):
            self.fail(f"{path}.provenance", "expected null, 'direct', or 'derived'")
        type_valid = self.boolean(
            self.field(trait, "typeValid", path), f"{path}.typeValid"
        )
        assumptions = self.assumptions(
            self.field(trait, "assumptions", path), f"{path}.assumptions"
        )
        axioms = self.axioms(self.field(trait, "axioms", path), f"{path}.axioms")
        self.dependency_metadata(assumptions, axioms, path)
        failures = self.failures(
            self.field(trait, "failures", path), f"{path}.failures"
        )
        status = self.status(self.field(trait, "status", path), f"{path}.status")
        self.implemented_common(
            path=path,
            status=status,
            type_valid=type_valid,
            assumptions=assumptions,
            axioms=axioms,
            failures=failures,
        )
        if status == "implemented":
            if certificate is None or provenance is None:
                self.fail(path, "implemented trait requires a certificate and provenance")
            if polarity != expected:
                self.fail(path, "implemented trait polarity must match the expected value")
        return status

    def space(self, value: Any, path: str) -> tuple[str, int, int]:
        space = self.object(value, path)
        space_id = self.string(self.field(space, "spaceId", path), f"{path}.spaceId")
        if _SPACE_ID_RE.fullmatch(space_id) is None:
            self.fail(f"{path}.spaceId", "expected a canonical space ID")
        self.optional_string(self.field(space, "catalogName", path), f"{path}.catalogName")
        presentation_status = self.presentation(
            self.field(space, "presentation", path), f"{path}.presentation"
        )
        traits = self.array(self.field(space, "traits", path), f"{path}.traits")
        trait_statuses = [
            self.trait(trait, f"{path}.traits[{index}]")
            for index, trait in enumerate(traits)
        ]
        property_ids = [trait["propertyId"] for trait in traits]
        if len(set(property_ids)) != len(property_ids):
            self.fail(f"{path}.traits", "propertyId values must be unique")
        failures = self.failures(self.field(space, "failures", path), f"{path}.failures")
        status = self.status(self.field(space, "status", path), f"{path}.status")

        child_statuses = [presentation_status, *trait_statuses]
        expected_status = (
            "invalid"
            if failures or "invalid" in child_statuses
            else "not-implemented"
            if "not-implemented" in child_statuses
            else "implemented"
        )
        if status != expected_status:
            self.fail(
                f"{path}.status",
                f"expected {expected_status!r} from the space's failures and child statuses",
            )
        nested_failures = len(failures) + len(space["presentation"]["failures"])
        nested_failures += sum(len(trait["failures"]) for trait in traits)
        return space_id, len(traits), nested_failures

    def report(self, value: Any) -> dict[str, Any]:
        report = self.object(value, "$ report")
        schema_version = self.integer(
            self.field(report, "schemaVersion", "$ report"), "$.schemaVersion"
        )
        if schema_version != SCHEMA_VERSION:
            self.fail(
                "$.schemaVersion",
                f"expected {SCHEMA_VERSION}, got {schema_version}",
            )
        scope = self.strings(
            self.field(report, "scope", "$ report"), "$.scope", unique=True
        )
        catalog_schema_version = self.integer(
            self.field(report, "catalogSchemaVersion", "$ report"),
            "$.catalogSchemaVersion",
        )
        if catalog_schema_version != CATALOG_SCHEMA_VERSION:
            self.fail(
                "$.catalogSchemaVersion",
                f"expected {CATALOG_SCHEMA_VERSION}, got {catalog_schema_version}",
            )

        hashes = self.object(
            self.field(report, "sourceHashes", "$ report"), "$.sourceHashes"
        )
        if set(hashes) != {"pibase", "independence"}:
            self.fail(
                "$.sourceHashes",
                "expected exactly the 'pibase' and 'independence' hashes",
            )
        for name in ("pibase", "independence"):
            digest = self.string(
                hashes[name], f"$.sourceHashes.{name}", nonempty=False
            )
            if _HASH_RE.fullmatch(digest) is None:
                self.fail(
                    f"$.sourceHashes.{name}",
                    "expected a 64-character lowercase hexadecimal digest",
                )

        spaces = self.array(self.field(report, "spaces", "$ report"), "$.spaces")
        space_data = [
            self.space(space, f"$.spaces[{index}]")
            for index, space in enumerate(spaces)
        ]
        space_ids = [space_id for space_id, _, _ in space_data]
        if len(set(space_ids)) != len(space_ids):
            self.fail("$.spaces", "spaceId values must be unique")
        if scope != space_ids:
            self.fail("$.scope", "must exactly match the ordered spaceId entries")

        report_failures = self.failures(
            self.field(report, "failures", "$ report"), "$.failures"
        )
        summary = self.object(self.field(report, "summary", "$ report"), "$.summary")
        summary_values = {
            name: self.integer(self.field(summary, name, "$.summary"), f"$.summary.{name}")
            for name in (
                "spaces",
                "implemented",
                "notImplemented",
                "invalid",
                "traits",
                "failures",
            )
        }
        statuses = [space["status"] for space in spaces]
        expected_summary = {
            "spaces": len(spaces),
            "implemented": statuses.count("implemented"),
            "notImplemented": statuses.count("not-implemented"),
            "invalid": statuses.count("invalid"),
            "traits": sum(trait_count for _, trait_count, _ in space_data),
            "failures": len(report_failures)
            + sum(failure_count for _, _, failure_count in space_data),
        }
        for name, expected in expected_summary.items():
            if summary_values[name] != expected:
                self.fail(
                    f"$.summary.{name}",
                    f"expected {expected} from the report entries, got {summary_values[name]}",
                )
        return report


def validate_report(value: Any) -> dict[str, Any]:
    """Validate and return a schema-v1 audit report."""
    return _Validator().report(value)


def parse_report(payload: str, *, source: str = "audit output") -> dict[str, Any]:
    """Parse and validate one JSON audit report."""
    try:
        value = json.loads(payload)
    except json.JSONDecodeError as error:
        raise AuditOutputError(f"{source} is not valid JSON: {error}") from error
    if not isinstance(value, dict):
        raise AuditOutputError(f"{source} must contain a JSON object")
    return validate_report(value)


def report_is_successful(report: dict[str, Any]) -> bool:
    """Determine success from validated report details, never summary claims alone."""
    return (
        not report["failures"]
        and report["summary"]["failures"] == 0
        and bool(report["spaces"])
        and all(
            space["status"] == "implemented"
            and not space["failures"]
            and space["presentation"]["status"] == "implemented"
            and not space["presentation"]["failures"]
            and all(
                trait["status"] == "implemented" and not trait["failures"]
                for trait in space["traits"]
            )
            for space in report["spaces"]
        )
    )


def run_space_audit(root: Path | str) -> AuditResult:
    """Run ``lake exe spaceAudit`` in ``root`` and parse stdout at every exit code."""
    resolved_root = Path(root).resolve()
    completed = subprocess.run(
        ["lake", "exe", "spaceAudit"],
        cwd=resolved_root,
        capture_output=True,
        text=True,
        check=False,
    )
    try:
        report = parse_report(completed.stdout, source="spaceAudit stdout")
    except AuditAdapterError as error:
        diagnostic = completed.stderr.strip()
        if diagnostic:
            raise type(error)(
                f"{error}\nspaceAudit stderr:\n{diagnostic}"
            ) from error
        raise
    return AuditResult(
        report=report,
        returncode=completed.returncode,
        stdout=completed.stdout,
        stderr=completed.stderr,
        source=f"lake exe spaceAudit in {resolved_root}",
    )


def load_audit_artifact(path: Path | str) -> AuditResult:
    """Load an explicitly selected JSON artifact without inspecting the source tree."""
    artifact = Path(path)
    if artifact.suffix.lower() != ".json":
        raise AuditOutputError(f"audit artifact must be a .json file: {artifact}")
    try:
        payload = artifact.read_text(encoding="utf-8")
    except OSError as error:
        raise AuditOutputError(f"could not read audit artifact {artifact}: {error}") from error
    report = parse_report(payload, source=f"audit artifact {artifact}")
    return AuditResult(
        report=report,
        returncode=None,
        stdout=payload,
        stderr="",
        source=str(artifact),
    )


def normalized_json(report: dict[str, Any]) -> str:
    """Serialize a validated report deterministically."""
    return json.dumps(report, ensure_ascii=False, sort_keys=True, separators=(",", ":"))


def _parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    source = parser.add_mutually_exclusive_group()
    source.add_argument(
        "--artifact",
        type=Path,
        help="read this explicit JSON artifact instead of invoking Lake",
    )
    source.add_argument(
        "--root",
        type=Path,
        default=Path.cwd(),
        help="project root in which to run 'lake exe spaceAudit' (default: cwd)",
    )
    return parser


def main(argv: list[str] | None = None) -> int:
    args = _parser().parse_args(argv)
    try:
        result = (
            load_audit_artifact(args.artifact)
            if args.artifact is not None
            else run_space_audit(args.root)
        )
    except AuditAdapterError as error:
        print(str(error), file=sys.stderr)
        return 2

    if result.stderr:
        print(result.stderr, file=sys.stderr, end="" if result.stderr.endswith("\n") else "\n")
    print(normalized_json(result.report))
    if result.returncode not in (None, 0):
        return result.returncode if 0 < result.returncode < 256 else 1
    return 0 if result.report_succeeded else 1


if __name__ == "__main__":
    raise SystemExit(main())

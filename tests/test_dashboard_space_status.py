from __future__ import annotations

import copy
import io
import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path
from unittest import mock

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))

import build_dashboard_data
from build_dashboard_data import space_audit_projection
from run_space_audit import (
    AuditOutputError,
    AuditResult,
    AuditReportValidationError,
    AuditUnsuccessfulError,
    load_audit_artifact,
    main as run_space_audit_main,
    parse_report,
    run_space_audit,
)

HASH_A = "a" * 64
HASH_B = "0" * 63 + "b"


def failure(code: str = "audit-failure") -> dict:
    return {"code": code, "message": "audit failed"}


def assumptions() -> dict:
    return {"expected": [], "declared": [], "used": [], "valid": True}


def axioms() -> dict:
    return {"axioms": [], "trusted": [], "conditional": [], "forbidden": []}


def presentation(status: str = "implemented", failures: list[dict] | None = None) -> dict:
    failures = [] if failures is None else failures
    implemented = status == "implemented"
    return {
        "carrier": "PiBase.S1" if implemented else None,
        "canonicalHomeomorph": "PiBase.S1_canonicalHomeomorph" if implemented else None,
        "typeValid": implemented,
        "assumptions": assumptions(),
        "axioms": axioms(),
        "failures": failures,
        "status": status,
    }


def trait(status: str = "implemented", failures: list[dict] | None = None) -> dict:
    failures = [] if failures is None else failures
    implemented = status == "implemented"
    return {
        "propertyId": "P000001",
        "name": "Compact",
        "expected": True,
        "polarity": True,
        "certificate": "PiBase.S1_P1" if implemented else None,
        "provenance": "direct" if implemented else None,
        "typeValid": implemented,
        "assumptions": assumptions(),
        "axioms": axioms(),
        "failures": failures,
        "status": status,
    }


def valid_report() -> dict:
    return {
        "schemaVersion": 1,
        "scope": ["S000001"],
        "catalogSchemaVersion": 1,
        "sourceHashes": {"pibase": HASH_A, "independence": HASH_B},
        "summary": {
            "spaces": 1,
            "implemented": 1,
            "notImplemented": 0,
            "invalid": 0,
            "traits": 1,
            "failures": 0,
        },
        "spaces": [
            {
                "spaceId": "S000001",
                "catalogName": "A space",
                "presentation": presentation(),
                "traits": [trait()],
                "failures": [],
                "status": "implemented",
            }
        ],
        "failures": [],
    }


def published_scope_report() -> dict:
    report = valid_report()
    spaces = []
    for space_id in build_dashboard_data.REQUIRED_SPACE_AUDIT_SCOPE:
        item = copy.deepcopy(report["spaces"][0])
        item["spaceId"] = space_id
        spaces.append(item)
    report["scope"] = list(build_dashboard_data.REQUIRED_SPACE_AUDIT_SCOPE)
    report["spaces"] = spaces
    report["summary"].update(
        {"spaces": len(spaces), "implemented": len(spaces), "traits": len(spaces)}
    )
    return report


def load_result(report: dict):
    with mock.patch("run_space_audit.subprocess.run") as run:
        run.return_value = subprocess.CompletedProcess(
            ["lake", "exe", "spaceAudit"], 0, json.dumps(report), ""
        )
        return run_space_audit(Path("/tmp/audit-root"))


class DashboardSpaceAuditProjectionTest(unittest.TestCase):
    def test_loader_accepts_the_exact_published_scope(self) -> None:
        report = published_scope_report()
        result = AuditResult(
            report=report,
            returncode=0,
            stdout=json.dumps(report),
            stderr="",
            source="fixture",
        )
        with (
            mock.patch.dict("os.environ", {}, clear=True),
            mock.patch.object(build_dashboard_data, "run_space_audit", return_value=result),
            mock.patch.object(build_dashboard_data, "sha256", side_effect=[HASH_A, HASH_B]),
        ):
            self.assertIs(build_dashboard_data.load_space_audit(), report)

    def test_loader_requires_the_exact_published_scope(self) -> None:
        report = valid_report()
        result = AuditResult(
            report=report,
            returncode=0,
            stdout=json.dumps(report),
            stderr="",
            source="fixture",
        )
        with (
            mock.patch.dict("os.environ", {}, clear=True),
            mock.patch.object(build_dashboard_data, "run_space_audit", return_value=result),
            mock.patch.object(build_dashboard_data, "sha256", side_effect=[HASH_A, HASH_B]),
            self.assertRaisesRegex(SystemExit, r"required pilot"),
        ):
            build_dashboard_data.load_space_audit()

    def test_artifact_loader_requires_an_exact_fresh_audit_match(self) -> None:
        report = published_scope_report()
        artifact_result = AuditResult(
            report=report,
            returncode=None,
            stdout=json.dumps(report),
            stderr="",
            source="artifact",
        )
        live_result = AuditResult(
            report=copy.deepcopy(report),
            returncode=0,
            stdout=json.dumps(report),
            stderr="",
            source="live",
        )
        with (
            mock.patch.dict(
                "os.environ",
                {"PIBASE_SPACE_AUDIT_ARTIFACT": "/tmp/space-audit.json"},
                clear=True,
            ),
            mock.patch.object(
                build_dashboard_data,
                "load_audit_artifact",
                return_value=artifact_result,
            ),
            mock.patch.object(
                build_dashboard_data, "run_space_audit", return_value=live_result
            ) as run,
            mock.patch.object(build_dashboard_data, "sha256", side_effect=[HASH_A, HASH_B]),
        ):
            self.assertIs(build_dashboard_data.load_space_audit(), report)
        run.assert_called_once_with(build_dashboard_data.LEAN_ROOT)

    def test_artifact_loader_rejects_forged_dependency_metadata(self) -> None:
        artifact = published_scope_report()
        live = copy.deepcopy(artifact)
        live["spaces"][0]["traits"][0]["axioms"] = {
            "axioms": ["Classical.choice"],
            "trusted": ["Classical.choice"],
            "conditional": [],
            "forbidden": [],
        }
        artifact_result = AuditResult(
            report=artifact,
            returncode=None,
            stdout=json.dumps(artifact),
            stderr="",
            source="artifact",
        )
        live_result = AuditResult(
            report=live,
            returncode=0,
            stdout=json.dumps(live),
            stderr="",
            source="live",
        )
        with (
            mock.patch.dict(
                "os.environ",
                {"PIBASE_SPACE_AUDIT_ARTIFACT": "/tmp/space-audit.json"},
                clear=True,
            ),
            mock.patch.object(
                build_dashboard_data,
                "load_audit_artifact",
                return_value=artifact_result,
            ),
            mock.patch.object(
                build_dashboard_data, "run_space_audit", return_value=live_result
            ),
            self.assertRaisesRegex(SystemExit, "does not exactly match"),
        ):
            build_dashboard_data.load_space_audit()

    def test_non_targeted_review_entry_has_no_fabricated_source_link(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            output = root / "output"
            data = {
                "properties": [],
                "spaces": [{"uid": "S000002", "name": "Unimplemented"}],
                "theorems": [],
            }
            statuses = {
                "S000002": {
                    "sourcePath": "",
                    "spaceAudit": {"targeted": False, "status": "not-targeted"},
                }
            }

            with (
                mock.patch.object(build_dashboard_data, "LEAN_ROOT", root),
                mock.patch.object(build_dashboard_data, "OUT_DIR", output),
                mock.patch.object(build_dashboard_data, "load_authors", return_value={}),
            ):
                build_dashboard_data.build_review_payloads(
                    data, statuses, "a" * 40, "2026-08-28T00:00:00Z", {}
                )

            payload = json.loads(
                (output / "review-spaces-000.json").read_text(encoding="utf-8")
            )

        entry = payload["entries"][0]
        self.assertEqual(entry["sourcePath"], "")
        self.assertEqual(entry["sourceUrl"], "")
        self.assertEqual(entry["code"], "")

    def test_property_status_uses_bundled_declaration(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            property_root = root / "PiBaseLean" / "Properties" / "P1"
            property_root.mkdir(parents=True)
            (root / "PiBaseLean.lean").write_text("module\n", encoding="utf-8")
            (property_root / "Defs.lean").write_text(
                "def underlyingProperty := True\n", encoding="utf-8"
            )
            (property_root / "Bundled.lean").write_text(
                "def P1 := True\n", encoding="utf-8"
            )

            with mock.patch.object(build_dashboard_data, "LEAN_ROOT", root):
                statuses, _ = build_dashboard_data.analyze_lean_tree()

        self.assertTrue(statuses["P000001"]["declarationPresent"])
        self.assertEqual(
            statuses["P000001"]["sourcePath"],
            "PiBaseLean/Properties/P1/Bundled.lean",
        )

    def test_audit_owns_targeted_semantics_and_traits(self) -> None:
        report = valid_report()
        catalog = {
            "properties": [{"uid": "P000001", "name": "Compact"}],
            "spaces": [
                {"uid": "S000001", "name": "A space"},
                {"uid": "S000002", "name": "Another space"},
            ],
            "traits": [
                {"space": "S000001", "property": "P000001", "value": True},
                {"space": "S000002", "property": "P000001", "value": True},
            ],
        }

        statuses, traits = space_audit_projection(report, catalog)

        targeted = statuses["S000001"]
        self.assertTrue(targeted["declarationPresent"])
        self.assertTrue(targeted["dependencyClean"])
        self.assertEqual(targeted["status"], "dependency-clean")
        self.assertTrue(targeted["spaceAudit"]["targeted"])
        self.assertEqual(traits["S000001"]["traits"], [{
            "property": "P000001",
            "name": "Compact",
            "value": True,
            "status": "asserted",
            "via": "PiBase.S1_P1",
        }])

        untargeted = statuses["S000002"]
        self.assertFalse(untargeted["declarationPresent"])
        self.assertFalse(untargeted["dependencyClean"])
        self.assertEqual(untargeted["status"], "missing-declaration")
        self.assertEqual(
            untargeted["spaceAudit"],
            {"status": "not-targeted", "targeted": False},
        )
        self.assertEqual(traits["S000002"]["traits"][0]["status"], "asserted")

    def test_projection_rejects_forged_trait_contracts(self) -> None:
        catalog = {
            "properties": [{"uid": "P000001", "name": "Compact"}],
            "spaces": [{"uid": "S000001", "name": "A space"}],
            "traits": [
                {"space": "S000001", "property": "P000001", "value": True},
            ],
        }
        mutations = {
            "missing direct trait": lambda report: report["spaces"][0].update(traits=[]),
            "wrong direct polarity": lambda report: report["spaces"][0]["traits"][0].update(
                expected=False, polarity=False
            ),
            "wrong direct provenance": lambda report: report["spaces"][0]["traits"][0].update(
                provenance="derived"
            ),
            "unknown property": lambda report: report["spaces"][0]["traits"][0].update(
                propertyId="P999999"
            ),
            "wrong property name": lambda report: report["spaces"][0]["traits"][0].update(
                name="Forged"
            ),
            "wrong catalog name": lambda report: report["spaces"][0].update(
                catalogName="Forged"
            ),
        }

        for label, mutate in mutations.items():
            with self.subTest(label=label):
                report = valid_report()
                mutate(report)
                with self.assertRaises(SystemExit):
                    space_audit_projection(report, catalog)

    def test_failed_target_uses_compatibility_debt_status(self) -> None:
        report = valid_report()
        report["spaces"][0]["presentation"] = presentation(
            "not-implemented", [failure("missing-homeomorph")]
        )
        report["spaces"][0]["presentation"]["carrier"] = "PiBase.S1"
        report["spaces"][0]["presentation"]["canonicalHomeomorph"] = (
            "PiBase.S1_canonicalHomeomorph"
        )
        report["spaces"][0]["status"] = "not-implemented"
        report["summary"].update({"implemented": 0, "notImplemented": 1, "failures": 1})
        catalog = {
            "properties": [{"uid": "P000001", "name": "Compact"}],
            "spaces": [{"uid": "S000001", "name": "A space"}],
            "traits": [
                {"space": "S000001", "property": "P000001", "value": True},
            ],
        }

        statuses, _ = space_audit_projection(report, catalog)

        self.assertFalse(statuses["S000001"]["dependencyClean"])
        self.assertEqual(statuses["S000001"]["status"], "local-debt")


class SpaceAuditAdapterTest(unittest.TestCase):
    def assert_invalid(self, report: dict, message: str) -> None:
        with self.assertRaisesRegex(AuditReportValidationError, message):
            parse_report(json.dumps(report))

    def test_valid_success_artifact(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            artifact = Path(temporary) / "space-audit.json"
            artifact.write_text(json.dumps(valid_report()), encoding="utf-8")

            result = load_audit_artifact(artifact)

        self.assertIsNone(result.process_succeeded)
        self.assertTrue(result.report_succeeded)
        self.assertTrue(result.succeeded)
        self.assertIs(result.require_success(), result)

    @mock.patch("run_space_audit.subprocess.run")
    def test_subprocess_success(self, run: mock.Mock) -> None:
        root = Path("/tmp/configurable-audit-root")
        run.return_value = subprocess.CompletedProcess(
            ["lake", "exe", "spaceAudit"], 0, json.dumps(valid_report()), ""
        )

        result = run_space_audit(root)

        self.assertTrue(result.process_succeeded)
        self.assertTrue(result.report_succeeded)
        run.assert_called_once_with(
            ["lake", "exe", "spaceAudit"],
            cwd=root.resolve(),
            capture_output=True,
            text=True,
            check=False,
        )

    @mock.patch("run_space_audit.subprocess.run")
    def test_nonzero_json_is_parsed_then_require_success_rejects_it(
        self, run: mock.Mock
    ) -> None:
        report = valid_report()
        item_failure = failure("missing-certificate")
        report["spaces"][0]["traits"][0] = trait("not-implemented", [item_failure])
        report["spaces"][0]["status"] = "not-implemented"
        report["summary"].update(
            {"implemented": 0, "notImplemented": 1, "failures": 1}
        )
        run.return_value = subprocess.CompletedProcess(
            ["lake", "exe", "spaceAudit"], 1, json.dumps(report), "diagnostic"
        )

        result = run_space_audit(Path("/tmp/audit-root"))

        self.assertEqual(result.returncode, 1)
        self.assertEqual(result.report["spaces"][0]["status"], "not-implemented")
        self.assertFalse(result.process_succeeded)
        self.assertFalse(result.report_succeeded)
        with self.assertRaises(AuditUnsuccessfulError) as raised:
            result.require_success()
        self.assertIs(raised.exception.result, result)

    @mock.patch("run_space_audit.subprocess.run")
    def test_nonzero_process_cannot_be_accepted_with_successful_report(
        self, run: mock.Mock
    ) -> None:
        run.return_value = subprocess.CompletedProcess(
            ["lake", "exe", "spaceAudit"], 7, json.dumps(valid_report()), "failed"
        )

        result = run_space_audit(Path("/tmp/audit-root"))

        self.assertTrue(result.report_succeeded)
        self.assertFalse(result.succeeded)
        with self.assertRaises(AuditUnsuccessfulError):
            result.require_success()

    def test_malformed_json(self) -> None:
        with self.assertRaises(AuditOutputError):
            parse_report("not json")

    @mock.patch("run_space_audit.subprocess.run")
    def test_subprocess_parse_failure_preserves_stderr(self, run: mock.Mock) -> None:
        run.return_value = subprocess.CompletedProcess(
            ["lake", "exe", "spaceAudit"], 1, "not json", "Lean runtime failed"
        )

        with self.assertRaisesRegex(AuditOutputError, r"Lean runtime failed"):
            run_space_audit(Path("/tmp/audit-root"))

    @mock.patch("run_space_audit.subprocess.run")
    def test_subprocess_validation_failure_preserves_stderr(self, run: mock.Mock) -> None:
        report = valid_report()
        report["schemaVersion"] = 2
        run.return_value = subprocess.CompletedProcess(
            ["lake", "exe", "spaceAudit"],
            1,
            json.dumps(report),
            "Lean validation diagnostic",
        )

        with self.assertRaisesRegex(
            AuditReportValidationError, r"Lean validation diagnostic"
        ):
            run_space_audit(Path("/tmp/audit-root"))

    @mock.patch("run_space_audit.run_space_audit")
    def test_cli_forwards_subprocess_stderr(self, run: mock.Mock) -> None:
        report = valid_report()
        run.return_value = AuditResult(
            report=report,
            returncode=0,
            stdout=json.dumps(report),
            stderr="Lean diagnostic\n",
            source="fixture",
        )

        with (
            mock.patch("sys.stdout", new_callable=io.StringIO),
            mock.patch("sys.stderr", new_callable=io.StringIO) as stderr,
        ):
            status = run_space_audit_main(["--root", "/tmp/audit-root"])

        self.assertEqual(status, 0)
        self.assertEqual(stderr.getvalue(), "Lean diagnostic\n")

    def test_schema_mismatch(self) -> None:
        report = valid_report()
        report["schemaVersion"] = 2
        self.assert_invalid(report, r"schemaVersion")

    def test_catalog_schema_mismatch(self) -> None:
        report = valid_report()
        report["catalogSchemaVersion"] = 999
        self.assert_invalid(report, r"catalogSchemaVersion")

    def test_duplicate_space_ids(self) -> None:
        report = valid_report()
        duplicate = copy.deepcopy(report["spaces"][0])
        report["spaces"].append(duplicate)
        report["scope"].append("S000002")
        report["summary"].update({"spaces": 2, "implemented": 2, "traits": 2})
        self.assert_invalid(report, r"spaceId values must be unique")

    def test_duplicate_trait_property_ids(self) -> None:
        report = valid_report()
        report["spaces"][0]["traits"].append(
            copy.deepcopy(report["spaces"][0]["traits"][0])
        )
        report["summary"]["traits"] = 2
        self.assert_invalid(report, r"propertyId values must be unique")

    def test_noncanonical_ids(self) -> None:
        report = valid_report()
        report["spaces"][0]["spaceId"] = "S1"
        report["scope"] = ["S1"]
        self.assert_invalid(report, r"canonical space ID")

        report = valid_report()
        report["spaces"][0]["traits"][0]["propertyId"] = "P1"
        self.assert_invalid(report, r"canonical property ID")

    def test_duplicate_scope(self) -> None:
        report = valid_report()
        report["scope"].append("S000001")
        self.assert_invalid(report, r"strings must be unique")

    def test_bad_hashes(self) -> None:
        for bad_hash in ("", "A" * 64, "a" * 63, "g" * 64):
            with self.subTest(hash=bad_hash):
                report = valid_report()
                report["sourceHashes"]["pibase"] = bad_hash
                self.assert_invalid(report, r"64-character lowercase hexadecimal")

        report = valid_report()
        report["sourceHashes"]["extra"] = HASH_A
        self.assert_invalid(report, r"expected exactly")

    def test_inconsistent_summary(self) -> None:
        report = valid_report()
        report["summary"]["implemented"] = 0
        self.assert_invalid(report, r"summary\.implemented")

    def test_summary_cannot_hide_nested_failures(self) -> None:
        report = valid_report()
        report["spaces"][0]["traits"][0] = trait(
            "not-implemented", [failure()]
        )
        report["spaces"][0]["status"] = "not-implemented"
        report["summary"].update({"implemented": 0, "notImplemented": 1})
        self.assert_invalid(report, r"summary\.failures")

    def test_report_failure_rejects_zero_exit_result(self) -> None:
        report = valid_report()
        report_failure = failure("registry-failure")
        report["failures"] = [report_failure]
        report["summary"]["failures"] = 1
        result = load_result(report)

        self.assertTrue(result.process_succeeded)
        self.assertFalse(result.report_succeeded)
        with self.assertRaises(AuditUnsuccessfulError) as raised:
            result.require_success()
        self.assertIs(raised.exception.result, result)

    def test_assumption_validity_must_match_arrays(self) -> None:
        report = valid_report()
        report["spaces"][0]["presentation"]["assumptions"]["expected"] = [
            "continuum-hypothesis"
        ]
        self.assert_invalid(report, r"assumptions\.valid")

    def test_axiom_cannot_be_omitted_from_classification(self) -> None:
        report = valid_report()
        report["spaces"][0]["presentation"]["axioms"] = {
            "axioms": ["Classical.choice"],
            "trusted": [],
            "conditional": [],
            "forbidden": [],
        }
        self.assert_invalid(report, r"axioms\.trusted.*exactly classify")

    def test_axiom_cannot_appear_in_multiple_classifications(self) -> None:
        report = valid_report()
        report["spaces"][0]["traits"][0]["axioms"] = {
            "axioms": ["Classical.choice"],
            "trusted": ["Classical.choice"],
            "conditional": ["Classical.choice"],
            "forbidden": [],
        }
        self.assert_invalid(report, r"axioms\.conditional.*exactly classify")

    def test_unknown_axiom_cannot_be_reclassified_as_trusted(self) -> None:
        report = valid_report()
        report["spaces"][0]["presentation"]["axioms"] = {
            "axioms": ["Unsafe.axiom"],
            "trusted": ["Unsafe.axiom"],
            "conditional": [],
            "forbidden": [],
        }
        self.assert_invalid(report, r"axioms\.trusted.*exactly classify")

    def test_conditional_assumptions_must_be_induced_by_axioms(self) -> None:
        report = valid_report()
        report["spaces"][0]["traits"][0]["assumptions"] = {
            "expected": ["continuum-hypothesis"],
            "declared": ["continuum-hypothesis"],
            "used": ["continuum-hypothesis"],
            "valid": True,
        }
        self.assert_invalid(report, r"assumptions\.used.*conditional axioms")

    def test_invalid_status(self) -> None:
        report = valid_report()
        report["spaces"][0]["status"] = "failed"
        self.assert_invalid(report, r"unsupported status")

    @mock.patch("run_space_audit.Path.read_text", autospec=True)
    @mock.patch("run_space_audit.subprocess.run")
    def test_subprocess_path_never_reads_lean_files(
        self, run: mock.Mock, read_text: mock.Mock
    ) -> None:
        run.return_value = subprocess.CompletedProcess(
            ["lake", "exe", "spaceAudit"], 0, json.dumps(valid_report()), ""
        )

        result = run_space_audit(Path("/tmp/audit-root"))

        self.assertTrue(result.succeeded)
        read_text.assert_not_called()

    def test_artifact_path_reads_only_explicit_json(self) -> None:
        report = valid_report()
        with tempfile.TemporaryDirectory() as temporary:
            artifact = Path(temporary) / "report.json"
            artifact.write_text(json.dumps(report), encoding="utf-8")
            original = Path.read_text
            reads: list[Path] = []

            def guarded_read_text(path: Path, *args, **kwargs) -> str:
                reads.append(path)
                if path.suffix == ".lean":
                    raise AssertionError("adapter attempted to read a Lean source file")
                return original(path, *args, **kwargs)

            with mock.patch.object(Path, "read_text", autospec=True, side_effect=guarded_read_text):
                result = load_audit_artifact(artifact)

        self.assertTrue(result.succeeded)
        self.assertEqual(reads, [artifact])


if __name__ == "__main__":
    unittest.main()

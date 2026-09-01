#!/usr/bin/env python3
"""Generate Lean data for auditing the complete Pi-Base space catalog.

This converter reads only the two JSON inputs. It records source obligations as data;
it does not inspect Lean source, detect declarations, or make proof claims.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import tempfile
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Sequence

ROOT = Path(__file__).resolve().parent.parent
DEFAULT_PIBASE = ROOT / "data" / "pibase.json"
DEFAULT_INDEPENDENCE = ROOT / "data" / "independence.json"
DEFAULT_GENERATED_OUTPUT = (
    ROOT / "PiBaseLean" / "Audit" / "Spaces" / "GeneratedCatalog.lean"
)
SCHEMA_VERSION = 1
SUPPORTED_BASE_THEORY = "ZFC"

ASSUMPTIONS = (
    ("CH", "continuumHypothesis"),
    ("not CH", "notContinuumHypothesis"),
    ("MA", "martinsAxiom"),
    ("GCH", "generalizedContinuumHypothesis"),
)
ASSUMPTION_IDS = dict(ASSUMPTIONS)


class CatalogGenerationError(ValueError):
    """The source catalog cannot be represented by this data schema."""


@dataclass(frozen=True)
class Property:
    id: str
    name: str


@dataclass(frozen=True)
class Trait:
    property_id: str
    value: bool


@dataclass(frozen=True)
class Space:
    id: str
    name: str
    traits: tuple[Trait, ...]
    assumptions: tuple[str, ...]


@dataclass(frozen=True)
class CatalogData:
    pibase_sha256: str
    independence_sha256: str
    properties: tuple[Property, ...]
    spaces: tuple[Space, ...]


def _expect_dict(value: Any, context: str) -> dict[str, Any]:
    if not isinstance(value, dict):
        raise CatalogGenerationError(f"{context} must be an object")
    return value


def _expect_list(value: Any, context: str) -> list[Any]:
    if not isinstance(value, list):
        raise CatalogGenerationError(f"{context} must be an array")
    return value


def _expect_string(value: Any, context: str) -> str:
    if not isinstance(value, str):
        raise CatalogGenerationError(f"{context} must be a string")
    return value


def _canonical_id(value: Any, prefix: str, context: str) -> str:
    text = _expect_string(value, context)
    if len(text) != 7 or text[0] != prefix or not text[1:].isascii() or not text[1:].isdigit():
        raise CatalogGenerationError(
            f"{context} must be a canonical {prefix} ID with six ASCII digits"
        )
    if int(text[1:]) <= 0:
        raise CatalogGenerationError(f"{context} must have a positive numeric component")
    return text


def _id_key(value: str) -> int:
    return int(value[1:])


def _read_json(path: Path, label: str) -> tuple[dict[str, Any], str]:
    try:
        raw = path.read_bytes()
    except OSError as error:
        raise CatalogGenerationError(f"cannot read {label} input {path}: {error}") from error
    digest = hashlib.sha256(raw).hexdigest()
    try:
        decoded = raw.decode("utf-8")
    except UnicodeDecodeError as error:
        raise CatalogGenerationError(f"{label} input is not valid UTF-8: {path}") from error
    try:
        parsed = json.loads(decoded)
    except json.JSONDecodeError as error:
        raise CatalogGenerationError(f"invalid JSON in {label} input {path}: {error}") from error
    return _expect_dict(parsed, label), digest


def load_catalog(pibase_path: Path, independence_path: Path) -> CatalogData:
    """Load and validate source data without consulting any Lean source files."""
    pibase, pibase_hash = _read_json(Path(pibase_path), "pibase")
    independence, independence_hash = _read_json(
        Path(independence_path), "independence"
    )

    base_theory = _expect_string(
        independence.get("baseTheory"), "independence.baseTheory"
    )
    if base_theory != SUPPORTED_BASE_THEORY:
        raise CatalogGenerationError(
            "unsupported independence base theory: "
            f"{base_theory!r}; expected {SUPPORTED_BASE_THEORY!r}"
        )

    property_rows = _expect_list(pibase.get("properties"), "pibase.properties")
    properties: dict[str, Property] = {}
    for index, raw_row in enumerate(property_rows):
        row = _expect_dict(raw_row, f"pibase.properties[{index}]")
        property_id = _canonical_id(
            row.get("uid"), "P", f"pibase.properties[{index}].uid"
        )
        if property_id in properties:
            raise CatalogGenerationError(f"duplicate property ID: {property_id}")
        properties[property_id] = Property(
            property_id,
            _expect_string(row.get("name"), f"property {property_id} name"),
        )

    space_rows = _expect_list(pibase.get("spaces"), "pibase.spaces")
    space_names: dict[str, str] = {}
    for index, raw_row in enumerate(space_rows):
        row = _expect_dict(raw_row, f"pibase.spaces[{index}]")
        space_id = _canonical_id(row.get("uid"), "S", f"pibase.spaces[{index}].uid")
        if space_id in space_names:
            raise CatalogGenerationError(f"duplicate space ID: {space_id}")
        space_names[space_id] = _expect_string(
            row.get("name"), f"space {space_id} name"
        )

    traits_by_space: dict[str, list[Trait]] = {space_id: [] for space_id in space_names}
    seen_traits: set[tuple[str, str]] = set()
    trait_rows = _expect_list(pibase.get("traits"), "pibase.traits")
    for index, raw_row in enumerate(trait_rows):
        row = _expect_dict(raw_row, f"pibase.traits[{index}]")
        space_id = _canonical_id(
            row.get("space"), "S", f"pibase.traits[{index}].space"
        )
        property_id = _canonical_id(
            row.get("property"), "P", f"pibase.traits[{index}].property"
        )
        if space_id not in space_names:
            raise CatalogGenerationError(f"trait references unknown space: {space_id}")
        if property_id not in properties:
            raise CatalogGenerationError(f"trait references unknown property: {property_id}")
        value = row.get("value")
        if type(value) is not bool:
            raise CatalogGenerationError(
                f"trait {space_id}/{property_id} value must be a Boolean"
            )
        key = (space_id, property_id)
        if key in seen_traits:
            raise CatalogGenerationError(
                f"duplicate direct trait obligation: {space_id}/{property_id}"
            )
        seen_traits.add(key)
        traits_by_space[space_id].append(Trait(property_id, value))

    assumptions_by_space: dict[str, list[str]] = {space_id: [] for space_id in space_names}
    conditional_rows = _expect_list(
        independence.get("conditionalSpaces"), "independence.conditionalSpaces"
    )
    conditional_space_rows: dict[str, int] = {}
    for index, raw_row in enumerate(conditional_rows):
        row = _expect_dict(raw_row, f"independence.conditionalSpaces[{index}]")
        space_id = _canonical_id(
            row.get("space"),
            "S",
            f"independence.conditionalSpaces[{index}].space",
        )
        if space_id not in space_names:
            raise CatalogGenerationError(
                f"conditional space references unknown space: {space_id}"
            )
        if space_id in conditional_space_rows:
            first_index = conditional_space_rows[space_id]
            raise CatalogGenerationError(
                "duplicate conditional space record for "
                f"{space_id}: independence.conditionalSpaces[{first_index}] and "
                f"independence.conditionalSpaces[{index}]"
            )
        conditional_space_rows[space_id] = index
        labels = _expect_list(
            row.get("assumptions"),
            f"independence.conditionalSpaces[{index}].assumptions",
        )
        target = assumptions_by_space[space_id]
        for label_index, raw_label in enumerate(labels):
            label = _expect_string(
                raw_label,
                f"independence.conditionalSpaces[{index}].assumptions[{label_index}]",
            )
            if label not in ASSUMPTION_IDS:
                raise CatalogGenerationError(f"unsupported assumption label: {label!r}")
            assumption_id = ASSUMPTION_IDS[label]
            if assumption_id not in target:
                target.append(assumption_id)

    sorted_properties = tuple(sorted(properties.values(), key=lambda row: _id_key(row.id)))
    spaces = tuple(
        Space(
            space_id,
            space_names[space_id],
            tuple(sorted(traits_by_space[space_id], key=lambda row: _id_key(row.property_id))),
            tuple(assumptions_by_space[space_id]),
        )
        for space_id in sorted(space_names, key=_id_key)
    )
    return CatalogData(
        pibase_hash,
        independence_hash,
        sorted_properties,
        spaces,
    )


def lean_string(value: str) -> str:
    """Render an arbitrary JSON string as an ASCII Lean string literal."""
    pieces = ['"']
    index = 0
    while index < len(value):
        character = value[index]
        codepoint = ord(character)
        if 0xD800 <= codepoint <= 0xDBFF:
            if index + 1 >= len(value):
                raise CatalogGenerationError("string contains an unpaired Unicode surrogate")
            low = ord(value[index + 1])
            if not 0xDC00 <= low <= 0xDFFF:
                raise CatalogGenerationError("string contains an unpaired Unicode surrogate")
            codepoint = 0x10000 + ((codepoint - 0xD800) << 10) + (low - 0xDC00)
            index += 1
        elif 0xDC00 <= codepoint <= 0xDFFF:
            raise CatalogGenerationError("string contains an unpaired Unicode surrogate")

        if character == '"':
            pieces.append(r'\"')
        elif character == "\\":
            pieces.append(r"\\")
        elif character == "\n":
            pieces.append(r"\n")
        elif character == "\r":
            pieces.append(r"\r")
        elif character == "\t":
            pieces.append(r"\t")
        elif codepoint < 0x20 or codepoint == 0x7F or codepoint > 0x7E:
            if codepoint <= 0xFFFF:
                pieces.append(f"\\u{codepoint:04x}")
            else:
                pieces.append(f"\\U{codepoint:08x}")
        else:
            pieces.append(character)
        index += 1
    pieces.append('"')
    return "".join(pieces)


def _render_traits(traits: tuple[Trait, ...]) -> str:
    if not traits:
        return "#[]"
    rows = [
        f"      {{ propertyId := {lean_string(row.property_id)}, value := {str(row.value).lower()} }}"
        for row in traits
    ]
    return "#[\n" + ",\n".join(rows) + "\n    ]"


def _render_assumption_ids(assumptions: tuple[str, ...]) -> str:
    if not assumptions:
        return "#[]"
    return "#[" + ", ".join(f".{value}" for value in assumptions) + "]"


def render_generated_catalog(data: CatalogData) -> str:
    lines = [
        "module",
        "",
        "-- This file is generated by scripts/gen_space_audit_catalog.py. Do not edit.",
        "public import PiBaseLean.Audit.Spaces.Catalog",
        "",
        "@[expose] public section",
        "",
        "namespace PiBase.Audit.Spaces",
        "",
        "/-- Complete Pi-Base source catalog data; this does not assert implementation status. -/",
        "def generatedCatalog : Catalog :=",
        f"  {{ schemaVersion := {SCHEMA_VERSION}",
        "    sourceHashes :=",
        f"      {{ pibase := {lean_string(data.pibase_sha256)}",
        f"        independence := {lean_string(data.independence_sha256)} }}",
        "    assumptions := #[",
    ]
    for index, (label, assumption_id) in enumerate(ASSUMPTIONS):
        comma = "," if index + 1 < len(ASSUMPTIONS) else ""
        lines.append(
            f"      {{ id := .{assumption_id}, label := {lean_string(label)} }}{comma}"
        )
    lines.extend(["    ]", "    properties := #["])
    for index, row in enumerate(data.properties):
        comma = "," if index + 1 < len(data.properties) else ""
        lines.append(
            f"      {{ id := {lean_string(row.id)}, name := {lean_string(row.name)} }}{comma}"
        )
    lines.extend(["    ]", "    spaces := #["])
    for index, row in enumerate(data.spaces):
        comma = "," if index + 1 < len(data.spaces) else ""
        lines.extend(
            [
                f"      {{ id := {lean_string(row.id)}",
                f"        name := {lean_string(row.name)}",
                f"        directTraits := {_render_traits(row.traits)}",
                "        conditionalAssumptions := "
                f"{_render_assumption_ids(row.assumptions)} }}{comma}",
            ]
        )
    lines.extend(["    ] }", "", "end PiBase.Audit.Spaces", ""])
    rendered = "\n".join(lines)
    if not rendered.isascii():
        raise AssertionError("generated Lean source must be ASCII")
    return rendered


def generate(pibase_path: Path, independence_path: Path) -> str:
    data = load_catalog(pibase_path, independence_path)
    return render_generated_catalog(data)


def _write_if_changed(path: Path, content: str) -> bool:
    path = Path(path)
    if path.is_file() and path.read_text(encoding="utf-8") == content:
        return False
    path.parent.mkdir(parents=True, exist_ok=True)
    descriptor, temporary_name = tempfile.mkstemp(
        prefix=f".{path.name}.", dir=path.parent, text=True
    )
    temporary = Path(temporary_name)
    try:
        with os.fdopen(descriptor, "w", encoding="utf-8", newline="") as handle:
            handle.write(content)
        os.replace(temporary, path)
    except BaseException:
        temporary.unlink(missing_ok=True)
        raise
    return True


def stale_outputs(expected: Sequence[tuple[Path, str]]) -> list[Path]:
    stale = []
    for path, content in expected:
        path = Path(path)
        if not path.is_file() or path.read_text(encoding="utf-8") != content:
            stale.append(path)
    return stale


def _parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--pibase", type=Path, default=DEFAULT_PIBASE)
    parser.add_argument("--independence", type=Path, default=DEFAULT_INDEPENDENCE)
    parser.add_argument("--generated-output", type=Path, default=DEFAULT_GENERATED_OUTPUT)
    parser.add_argument(
        "--check", action="store_true", help="fail on missing or stale output without writing"
    )
    return parser


def run(argv: Sequence[str] | None = None) -> int:
    args = _parser().parse_args(argv)
    generated_source = generate(args.pibase, args.independence)
    expected = ((args.generated_output, generated_source),)
    if args.check:
        stale = stale_outputs(expected)
        if stale:
            for path in stale:
                print(f"stale or missing: {path}", file=os.sys.stderr)
            return 1
        print("space audit catalog is current")
        return 0

    for path, content in expected:
        changed = _write_if_changed(path, content)
        print(f"{'wrote' if changed else 'unchanged'} {path}")
    return 0


def main() -> None:
    try:
        raise SystemExit(run())
    except CatalogGenerationError as error:
        raise SystemExit(f"space audit catalog generation error: {error}") from error


if __name__ == "__main__":
    main()

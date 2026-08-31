from __future__ import annotations

import hashlib
import json
import sys
import tempfile
import unittest
from contextlib import redirect_stderr, redirect_stdout
from io import StringIO
from pathlib import Path
from unittest import mock

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "scripts"))

import gen_space_audit_catalog as generator


class SpaceAuditCatalogGeneratorTest(unittest.TestCase):
    def setUp(self) -> None:
        self.temporary = tempfile.TemporaryDirectory()
        self.root = Path(self.temporary.name)
        self.pibase_path = self.root / "inputs" / "pibase.json"
        self.independence_path = self.root / "inputs" / "independence.json"
        self.catalog_output = self.root / "out" / "Catalog.lean"
        self.generated_output = self.root / "out" / "GeneratedCatalog.lean"
        self.catalog_output.parent.mkdir(parents=True, exist_ok=True)
        self.catalog_output.write_text("handwritten schema\n", encoding="utf-8")
        self.pibase = {
            "spaces": [
                {"uid": "S000010", "name": 'Quote " slash \\ line\n\t\r\u0000 caf\u00e9'},
                {"uid": "S000002", "name": "Second"},
                {"uid": "S000001", "name": "First"},
            ],
            "properties": [
                {"uid": "P000052", "name": "Discrete"},
                {"uid": "P000002", "name": "T one"},
            ],
            "traits": [
                {"space": "S000010", "property": "P000052", "value": False},
                {"space": "S000010", "property": "P000002", "value": True},
            ],
        }
        self.independence = {
            "baseTheory": "ZFC",
            "conditionalSpaces": [
                {
                    "space": "S000010",
                    "assumptions": ["MA", "not CH", "MA"],
                    "condition": "first context",
                },
                {
                    "space": "S000002",
                    "assumptions": ["GCH", "CH"],
                    "condition": "second context",
                },
            ]
        }
        self.write_inputs()

    def tearDown(self) -> None:
        self.temporary.cleanup()

    def write_inputs(self, *, indent: int | None = None) -> tuple[bytes, bytes]:
        self.pibase_path.parent.mkdir(parents=True, exist_ok=True)
        pibase_bytes = json.dumps(
            self.pibase, ensure_ascii=True, indent=indent, separators=None if indent else (",", ":")
        ).encode("utf-8")
        independence_bytes = json.dumps(
            self.independence,
            ensure_ascii=True,
            indent=indent,
            separators=None if indent else (",", ":"),
        ).encode("utf-8")
        self.pibase_path.write_bytes(pibase_bytes)
        self.independence_path.write_bytes(independence_bytes)
        return pibase_bytes, independence_bytes

    def cli_args(self, *extra: str) -> list[str]:
        return [
            "--pibase",
            str(self.pibase_path),
            "--independence",
            str(self.independence_path),
            "--generated-output",
            str(self.generated_output),
            *extra,
        ]

    def test_generation_is_deterministic_complete_and_numerically_sorted(self) -> None:
        first = generator.generate(self.pibase_path, self.independence_path)
        second = generator.generate(self.pibase_path, self.independence_path)
        self.assertEqual(first, second)
        self.assertLess(first.index('id := "P000002"'), first.index('id := "P000052"'))
        self.assertLess(first.index('id := "S000001"'), first.index('id := "S000002"'))
        self.assertLess(first.index('id := "S000002"'), first.index('id := "S000010"'))
        self.assertEqual(first.count('      { id := "S'), 3)
        self.assertIn('id := "S000002"\n        name := "Second"\n        directTraits := #[]', first)

    def test_generated_catalog_uses_schema_version_constant(self) -> None:
        with mock.patch.object(generator, "SCHEMA_VERSION", 73):
            generated = generator.generate(self.pibase_path, self.independence_path)

        self.assertIn("  { schemaVersion := 73\n", generated)
        self.assertNotIn("  { schemaVersion := 1\n", generated)

    def test_direct_traits_preserve_boolean_polarity_and_order(self) -> None:
        data = generator.load_catalog(self.pibase_path, self.independence_path)
        space = next(row for row in data.spaces if row.id == "S000010")
        self.assertEqual(
            space.traits,
            (
                generator.Trait("P000002", True),
                generator.Trait("P000052", False),
            ),
        )
        output = generator.render_generated_catalog(data)
        positive = '{ propertyId := "P000002", value := true }'
        negative = '{ propertyId := "P000052", value := false }'
        self.assertLess(output.index(positive), output.index(negative))
        self.assertNotIn("theorem", output)

    def test_assumptions_have_stable_ids_and_preserve_first_occurrence_order(self) -> None:
        data = generator.load_catalog(self.pibase_path, self.independence_path)
        space = next(row for row in data.spaces if row.id == "S000010")
        self.assertEqual(
            space.assumptions,
            (
                "martinsAxiom",
                "notContinuumHypothesis",
            ),
        )
        second_space = next(row for row in data.spaces if row.id == "S000002")
        self.assertEqual(
            second_space.assumptions,
            ("generalizedContinuumHypothesis", "continuumHypothesis"),
        )
        output = generator.render_generated_catalog(data)
        for label, assumption_id in generator.ASSUMPTIONS:
            self.assertIn(
                f'{{ id := .{assumption_id}, label := "{label}" }}', output
            )
        self.assertIn(
            "conditionalAssumptions := #[.martinsAxiom, .notContinuumHypothesis]",
            output,
        )
        self.assertIn(
            "conditionalAssumptions := #[.generalizedContinuumHypothesis, "
            ".continuumHypothesis]",
            output,
        )
        self.assertNotIn("PiBase.ContinuumHypothesis", output)

    def test_duplicate_conditional_space_record_is_rejected(self) -> None:
        self.independence["conditionalSpaces"][1]["space"] = "S000010"
        self.write_inputs()
        with self.assertRaisesRegex(
            generator.CatalogGenerationError,
            r"duplicate conditional space record for S000010: "
            r"independence\.conditionalSpaces\[0\] and "
            r"independence\.conditionalSpaces\[1\]",
        ):
            generator.load_catalog(self.pibase_path, self.independence_path)

    def test_missing_base_theory_is_rejected(self) -> None:
        del self.independence["baseTheory"]
        self.write_inputs()
        with self.assertRaisesRegex(
            generator.CatalogGenerationError,
            r"^independence\.baseTheory must be a string$",
        ):
            generator.load_catalog(self.pibase_path, self.independence_path)

    def test_non_string_base_theory_is_rejected(self) -> None:
        for value in (None, True, 42, [], {}):
            with self.subTest(value=value):
                self.independence["baseTheory"] = value
                self.write_inputs()
                with self.assertRaisesRegex(
                    generator.CatalogGenerationError,
                    r"^independence\.baseTheory must be a string$",
                ):
                    generator.load_catalog(self.pibase_path, self.independence_path)

    def test_unsupported_base_theory_is_rejected(self) -> None:
        for value in ("NBG", "zfc", ""):
            with self.subTest(value=value):
                self.independence["baseTheory"] = value
                self.write_inputs()
                with self.assertRaisesRegex(
                    generator.CatalogGenerationError,
                    rf"^unsupported independence base theory: {value!r}; "
                    rf"expected {generator.SUPPORTED_BASE_THEORY!r}$",
                ):
                    generator.load_catalog(self.pibase_path, self.independence_path)

    def test_unknown_assumption_is_rejected(self) -> None:
        self.independence["conditionalSpaces"][0]["assumptions"] = ["PFA"]
        self.write_inputs()
        with self.assertRaisesRegex(
            generator.CatalogGenerationError, "unsupported assumption label: 'PFA'"
        ):
            generator.load_catalog(self.pibase_path, self.independence_path)

    def test_lean_string_escapes_arbitrary_json_strings_as_ascii(self) -> None:
        escaped = generator.lean_string('"\\\n\r\t\x00\x7f caf\u00e9 \U0001f600')
        self.assertEqual(
            escaped,
            '"\\"\\\\\\n\\r\\t\\u0000\\u007f caf\\u00e9 \\U0001f600"',
        )
        self.assertTrue(escaped.isascii())
        self.assertEqual(generator.lean_string("\ud83d\ude00"), '"\\U0001f600"')
        for invalid in ("\ud800", "\ud800x", "\udc00"):
            with self.subTest(invalid=repr(invalid)):
                with self.assertRaisesRegex(
                    generator.CatalogGenerationError, "unpaired Unicode surrogate"
                ):
                    generator.lean_string(invalid)

    def test_hashes_cover_exact_input_bytes(self) -> None:
        pibase_bytes, independence_bytes = self.write_inputs()
        data = generator.load_catalog(self.pibase_path, self.independence_path)
        self.assertEqual(data.pibase_sha256, hashlib.sha256(pibase_bytes).hexdigest())
        self.assertEqual(
            data.independence_sha256, hashlib.sha256(independence_bytes).hexdigest()
        )
        before = generator.render_generated_catalog(data)

        reformatted, _ = self.write_inputs(indent=2)
        changed = generator.load_catalog(self.pibase_path, self.independence_path)
        self.assertEqual(changed.pibase_sha256, hashlib.sha256(reformatted).hexdigest())
        self.assertNotEqual(changed.pibase_sha256, data.pibase_sha256)
        self.assertNotEqual(generator.render_generated_catalog(changed), before)

    def test_check_detects_missing_and_stale_outputs_without_writing(self) -> None:
        with mock.patch.object(
            generator, "_write_if_changed", side_effect=AssertionError("write attempted")
        ), mock.patch.object(
            generator.tempfile, "mkstemp", side_effect=AssertionError("temp attempted")
        ), mock.patch.object(
            generator.os, "replace", side_effect=AssertionError("replace attempted")
        ):
            stderr = StringIO()
            with redirect_stderr(stderr):
                self.assertEqual(generator.run(self.cli_args("--check")), 1)
        self.assertEqual(
            self.catalog_output.read_text(encoding="utf-8"), "handwritten schema\n"
        )
        self.assertFalse(self.generated_output.exists())
        self.assertNotIn(str(self.catalog_output), stderr.getvalue())
        self.assertIn(str(self.generated_output), stderr.getvalue())

        self.assertEqual(generator.run(self.cli_args()), 0)
        self.generated_output.write_text("stale\n", encoding="utf-8")
        stale = self.generated_output.read_bytes()
        with mock.patch.object(
            generator, "_write_if_changed", side_effect=AssertionError("write attempted")
        ):
            with redirect_stderr(StringIO()):
                self.assertEqual(generator.run(self.cli_args("--check")), 1)
        self.assertEqual(
            self.catalog_output.read_text(encoding="utf-8"), "handwritten schema\n"
        )
        self.assertEqual(self.generated_output.read_bytes(), stale)

    def test_normal_cli_uses_configurable_atomic_idempotent_output(self) -> None:
        with redirect_stdout(StringIO()):
            self.assertEqual(generator.run(self.cli_args()), 0)
        self.assertEqual(
            self.catalog_output.read_text(encoding="utf-8"), "handwritten schema\n"
        )
        self.assertTrue(self.generated_output.is_file())
        contents = self.generated_output.read_bytes()
        mtime = self.generated_output.stat().st_mtime_ns

        with redirect_stdout(StringIO()):
            self.assertEqual(generator.run(self.cli_args()), 0)
        self.assertEqual(self.generated_output.read_bytes(), contents)
        self.assertEqual(self.generated_output.stat().st_mtime_ns, mtime)
        self.assertEqual(
            self.catalog_output.read_text(encoding="utf-8"), "handwritten schema\n"
        )
        self.assertEqual(list(self.catalog_output.parent.glob(".*.lean.*")), [])

        with redirect_stdout(StringIO()):
            self.assertEqual(generator.run(self.cli_args("--check")), 0)


if __name__ == "__main__":
    unittest.main()

from __future__ import annotations

import sys
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "scripts"))

import gen_spaces


class GenSpacesTest(unittest.TestCase):
    def setUp(self) -> None:
        self.temporary = tempfile.TemporaryDirectory()
        self.root = Path(self.temporary.name)
        (self.root / "PiBaseLean").mkdir()

    def tearDown(self) -> None:
        self.temporary.cleanup()

    def write_module(
        self,
        number: int,
        *,
        directory: str | None = None,
        defs_extra: str = "",
        lemmas_extra: str = "",
        generated_extra: str = "",
    ) -> Path:
        space_id = f"S{number}"
        target = self.root / "PiBaseLean" / "Spaces" / (directory or space_id)
        target.mkdir(parents=True)
        (target / "Defs.lean").write_text(
            "module\n\n"
            f"def {space_id} : Type := Unit\n"
            f"noncomputable def {space_id}_canonicalHomeomorph := id\n"
            f"{defs_extra}",
            encoding="utf-8",
        )
        (target / "Lemmas.lean").write_text(
            "module\n\n"
            f"public import PiBaseLean.Spaces.{space_id}.Defs\n"
            f"{lemmas_extra}",
            encoding="utf-8",
        )
        (target / "Generated.lean").write_text(
            "module\n\n"
            f"{gen_spaces.GENERATED_HEADER}"
            f"public import PiBaseLean.Spaces.{space_id}.Lemmas\n"
            f"{generated_extra}",
            encoding="utf-8",
        )
        return target

    def test_normalize_padded_and_unpadded_ids(self) -> None:
        for value in ("147", "000147", "S147", "S000147", "s000147", 147):
            with self.subTest(value=value):
                self.assertEqual(gen_spaces.normalize_space_id(value), "S147")

        for value in ("", "S", "S0", "000000", "S-1", "space147", "147x"):
            with self.subTest(value=value):
                with self.assertRaises(gen_spaces.SpaceValidationError):
                    gen_spaces.normalize_space_id(value)

    def test_scaffold_creates_exact_three_files_and_never_overwrites(self) -> None:
        defs, lemmas, generated, created = gen_spaces.scaffold_space(
            "S000147", self.root
        )
        self.assertTrue(created)
        self.assertEqual(
            defs,
            self.root.resolve() / "PiBaseLean" / "Spaces" / "S147" / "Defs.lean",
        )
        self.assertEqual(
            {path.name for path in defs.parent.iterdir()},
            {"Defs.lean", "Lemmas.lean", "Generated.lean"},
        )
        self.assertIn("def S147 : Type", defs.read_text(encoding="utf-8"))
        self.assertIn(
            "public import PiBaseLean.Spaces.S147.Defs",
            lemmas.read_text(encoding="utf-8"),
        )
        self.assertEqual(
            generated.read_text(encoding="utf-8"),
            gen_spaces._generated_template("S147"),
        )

        contents = {
            defs: "hand-written defs\n",
            lemmas: "hand-written lemmas\n",
            generated: "generator-owned output\n",
        }
        for path, content in contents.items():
            path.write_text(content, encoding="utf-8")
        same_defs, same_lemmas, same_generated, created = gen_spaces.scaffold_space(
            "147", self.root
        )
        self.assertFalse(created)
        self.assertEqual(
            (same_defs, same_lemmas, same_generated), (defs, lemmas, generated)
        )
        for path, content in contents.items():
            self.assertEqual(path.read_text(encoding="utf-8"), content)

    def test_scaffold_rejects_partial_or_populated_incomplete_directory(self) -> None:
        target = self.root / "PiBaseLean" / "Spaces" / "S8"
        target.mkdir(parents=True)
        defs = target / "Defs.lean"
        defs.write_text("existing work\n", encoding="utf-8")
        (target / "notes.txt").write_text("do not overwrite\n", encoding="utf-8")

        with self.assertRaisesRegex(
            gen_spaces.SpaceValidationError, "incomplete space directory"
        ):
            gen_spaces.scaffold_space("S000008", self.root)

        self.assertEqual(defs.read_text(encoding="utf-8"), "existing work\n")
        self.assertFalse((target / "Lemmas.lean").exists())
        self.assertFalse((target / "Generated.lean").exists())

    def test_aggregate_uses_only_complete_modules_in_numeric_order(self) -> None:
        self.write_module(10)
        self.write_module(2)
        partial = self.root / "PiBaseLean" / "Spaces" / "S3"
        partial.mkdir()
        (partial / "Defs.lean").write_text("def S3 := Unit\n", encoding="utf-8")
        (partial / "Lemmas.lean").write_text("module\n", encoding="utf-8")

        all_path, changed = gen_spaces.regenerate_all(self.root)
        self.assertTrue(changed)
        self.assertEqual(
            all_path.read_text(encoding="utf-8"),
            "module\n\n"
            "-- This file is generated by scripts/gen_spaces.py.\n"
            "public meta import PiBaseLean.Audit.Spaces.Audit\n"
            "public import PiBaseLean.Spaces.S2.Generated\n"
            "public import PiBaseLean.Spaces.S10.Generated\n",
        )

        before = all_path.stat().st_mtime_ns
        same_path, changed = gen_spaces.regenerate_all(self.root)
        self.assertFalse(changed)
        self.assertEqual(same_path, all_path)
        self.assertEqual(all_path.stat().st_mtime_ns, before)

    def test_validation_checks_paths_modules_declarations_and_imports(self) -> None:
        valid = self.write_module(4)
        self.write_module(5, directory="S0005")
        broken = self.write_module(
            6,
            defs_extra="public import PiBaseLean.Spaces.S7.Defs\n",
            lemmas_extra="public import PiBaseLean.Spaces.S8.Lemmas\n",
            generated_extra="public import PiBaseLean.Spaces.S9.Generated\n",
        )
        missing_edges = self.write_module(7)
        (missing_edges / "Lemmas.lean").write_text("module\n", encoding="utf-8")
        (missing_edges / "Generated.lean").write_text("module\n", encoding="utf-8")
        (broken / "Defs.lean").write_text(
            "module\n"
            "def Wrong : Type := Unit\n"
            "public import PiBaseLean.Spaces.S7.Defs\n",
            encoding="utf-8",
        )
        partial = self.root / "PiBaseLean" / "Spaces" / "S11"
        partial.mkdir()
        (partial / "Defs.lean").write_text("def S11 := Unit\n", encoding="utf-8")
        (partial / "Lemmas.lean").write_text("module\n", encoding="utf-8")
        (self.root / "PiBaseLean" / "Spaces" / "Notes.lean").write_text(
            "notes\n", encoding="utf-8"
        )
        self.assertTrue(valid.is_dir())

        errors = gen_spaces.validate_tree(self.root, check_all=False)
        joined = "\n".join(errors)
        self.assertIn("non-canonical numbered space path", joined)
        self.assertIn("S6/Defs.lean: missing literal def S6", joined)
        self.assertIn("S6/Defs.lean: missing def S6_canonicalHomeomorph", joined)
        self.assertIn("PiBaseLean.Spaces.S7.Defs", joined)
        self.assertIn("PiBaseLean.Spaces.S8.Lemmas", joined)
        self.assertIn("PiBaseLean.Spaces.S9.Generated", joined)
        self.assertIn(
            "S7/Lemmas.lean: missing required numbered space import: "
            "PiBaseLean.Spaces.S7.Defs",
            joined,
        )
        self.assertIn(
            "S7/Generated.lean: missing required numbered space import: "
            "PiBaseLean.Spaces.S7.Lemmas",
            joined,
        )
        self.assertIn("S11: incomplete module; missing Generated.lean", joined)
        self.assertIn("unexpected path in spaces directory", joined)
        self.assertNotIn("S4/Lemmas.lean: numbered space import", joined)
        self.assertNotIn("S4/Generated.lean: numbered space import", joined)

    def test_check_mode_is_read_only_and_detects_stale_aggregate(self) -> None:
        self.write_module(1)
        all_path = self.root / "PiBaseLean" / "Spaces" / "All.lean"
        all_path.write_text("stale\n", encoding="utf-8")

        with self.assertRaisesRegex(
            gen_spaces.SpaceValidationError, "stale generated aggregate"
        ):
            gen_spaces.run(["--check", "--root", str(self.root)])
        self.assertEqual(all_path.read_text(encoding="utf-8"), "stale\n")

        _, changed = gen_spaces.regenerate_all(self.root)
        self.assertTrue(changed)
        self.assertEqual(gen_spaces.run(["--check", "--root", str(self.root)]), 0)

    def test_cli_scaffold_and_regeneration_are_idempotent(self) -> None:
        self.assertEqual(gen_spaces.run(["S000012", "--root", str(self.root)]), 0)
        target = self.root / "PiBaseLean" / "Spaces" / "S12"
        defs = target / "Defs.lean"
        lemmas = target / "Lemmas.lean"
        generated = target / "Generated.lean"
        all_path = target.parent / "All.lean"
        contents = {
            path: path.read_text(encoding="utf-8")
            for path in (defs, lemmas, generated, all_path)
        }
        mtimes = {path: path.stat().st_mtime_ns for path in contents}

        self.assertEqual(gen_spaces.run(["12", "--root", str(self.root)]), 0)
        self.assertEqual(
            {path: path.read_text(encoding="utf-8") for path in contents}, contents
        )
        self.assertEqual({path: path.stat().st_mtime_ns for path in contents}, mtimes)
        with self.assertRaisesRegex(
            gen_spaces.SpaceValidationError, "proof debt prevents implementation status"
        ):
            gen_spaces.run(["--check", "--root", str(self.root)])


if __name__ == "__main__":
    unittest.main()

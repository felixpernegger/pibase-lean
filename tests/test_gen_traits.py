import importlib.util
import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[1]
SCRIPT = REPO_ROOT / "scripts" / "gen_traits.py"
SPEC = importlib.util.spec_from_file_location("gen_traits", SCRIPT)
assert SPEC and SPEC.loader
GEN_TRAITS = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = GEN_TRAITS
SPEC.loader.exec_module(GEN_TRAITS)


def atom(prop, value=True):
    return {"kind": "atom", "property": prop, "value": value}


def implication(uid, antecedents, conclusion):
    when = antecedents[0] if len(antecedents) == 1 else {
        "kind": "and",
        "subs": antecedents,
    }
    return {"uid": uid, "when": when, "then": conclusion}


class CloseTests(unittest.TestCase):
    def test_generates_positive_forward_and_constructive_contrapositive(self):
        theorem = implication(
            "T000007",
            [atom("P000001"), atom("P000002")],
            atom("P000003"),
        )

        known, derivations, _ = GEN_TRAITS.close(
            {"P000001": True, "P000002": True},
            [theorem],
            {"P000001", "P000002", "P000003"},
        )
        self.assertIs(known["P000003"], True)
        self.assertEqual(derivations["P000003"][0], "implication")

        known, derivations, _ = GEN_TRAITS.close(
            {"P000002": True, "P000003": False},
            [theorem],
            {"P000001", "P000002", "P000003"},
        )
        self.assertIs(known["P000001"], False)
        self.assertEqual(derivations["P000001"][0], "contrapositive")

    def test_rejects_negative_antecedent_and_negative_conclusion(self):
        negative_antecedent = implication(
            "T000008", [atom("P000001", False)], atom("P000002")
        )
        negative_conclusion = implication(
            "T000009", [atom("P000001")], atom("P000002", False)
        )

        known, derivations, _ = GEN_TRAITS.close(
            {"P000002": False},
            [negative_antecedent, negative_conclusion],
            {"P000001", "P000002"},
        )

        self.assertNotIn("P000001", known)
        self.assertEqual(derivations, {"P000002": ("direct", None, ())})

    def test_does_not_overwrite_conflicting_direct_data(self):
        theorem = implication(
            "T000010", [atom("P000001")], atom("P000002")
        )
        known, derivations, _ = GEN_TRAITS.close(
            {"P000001": True, "P000002": False},
            [theorem],
            {"P000001", "P000002"},
        )
        self.assertIs(known["P000002"], False)
        self.assertEqual(derivations["P000002"][0], "direct")


class AvailabilityTests(unittest.TestCase):
    def test_requires_expected_declaration_not_only_numbered_directory(self):
        with tempfile.TemporaryDirectory() as directory:
            theorem_root = Path(directory) / "PiBaseLean" / "Theorems"
            declared = theorem_root / "T1" / "Theorem.lean"
            declared.parent.mkdir(parents=True)
            declared.write_text("theorem T1 : True := trivial\n", encoding="utf-8")
            missing = theorem_root / "T500" / "Theorem.lean"
            missing.parent.mkdir(parents=True)
            missing.write_text("theorem differentlyNamed : True := trivial\n", encoding="utf-8")

            self.assertEqual(GEN_TRAITS.available("T", directory), {"T000001"})

    def test_properties_require_bundled_definition(self):
        with tempfile.TemporaryDirectory() as directory:
            property_root = Path(directory) / "PiBaseLean" / "Properties"
            bundled = property_root / "P1" / "Bundled.lean"
            bundled.parent.mkdir(parents=True)
            bundled.write_text("def P1 := True\n", encoding="utf-8")
            defs_only = property_root / "P2" / "Defs.lean"
            defs_only.parent.mkdir(parents=True)
            defs_only.write_text("def P2 := True\n", encoding="utf-8")
            wrong_name = property_root / "P3" / "Bundled.lean"
            wrong_name.parent.mkdir(parents=True)
            wrong_name.write_text("def differentlyNamed := True\n", encoding="utf-8")

            self.assertEqual(GEN_TRAITS.available("P", directory), {"P000001"})


class RenderingTests(unittest.TestCase):
    def setUp(self):
        self.theorem = implication(
            "T000007",
            [atom("P000001"), atom("P000002")],
            atom("P000003"),
        )

    def render(self, seed, independence=None):
        return GEN_TRAITS.render_generated_module(
            "S000147",
            seed,
            [self.theorem],
            {"P000001", "P000002", "P000003"},
            independence or {},
        )

    def test_renders_complete_module_with_exact_deterministic_imports(self):
        output = self.render({"P000001": True, "P000002": True})

        expected_prefix = (
            "module\n\n"
            f"{GEN_TRAITS.GENERATED_HEADER}\n"
            "public import PiBaseLean.Spaces.S147.Lemmas\n"
            "public import PiBaseLean.Properties.P3.Bundled\n"
            "public import PiBaseLean.Theorems.T7.Theorem\n\n"
            "@[expose] public section\n\n"
            "namespace PiBase.Formal\n"
        )
        self.assertTrue(output.startswith(expected_prefix), output)
        self.assertTrue(output.endswith("end PiBase.Formal\n"))
        self.assertIn("theorem S147_P3 : P3 PiBase.S147 :=", output)
        self.assertIn(
            "T7 PiBase.S147 inferInstance ⟨S147_P1, S147_P2⟩", output
        )
        certificate = (
            "register_certificate S000147 P000003 true\n"
            "  proof PiBase.Formal.S147_P3\n"
            "  provenance derived\n"
            "  assumptions []"
        )
        self.assertIn(certificate, output)
        self.assertLess(output.index("theorem S147_P3"), output.index(certificate))

    def test_never_generates_direct_theorems_or_certificates(self):
        output = self.render({"P000001": True, "P000002": True})

        self.assertNotIn("theorem S147_P1", output)
        self.assertNotIn("theorem S147_P2", output)
        self.assertNotIn("provenance direct", output)
        self.assertNotIn("register_certificate S000147 P000001", output)
        self.assertNotIn("register_certificate S000147 P000002", output)

    def test_renders_sound_contrapositive(self):
        output = self.render({"P000002": True, "P000003": False})

        proof = (
            "theorem S147_P1_not : ¬ P1 PiBase.S147 := by\n"
            "  intro h\n"
            "  exact S147_P3_not (T7 PiBase.S147 inferInstance ⟨h, S147_P2⟩)"
        )
        certificate = (
            "register_certificate S000147 P000001 false\n"
            "  proof PiBase.Formal.S147_P1_not\n"
            "  provenance derived\n"
            "  assumptions []"
        )
        self.assertIn(f"{proof}\n\n{certificate}", output)

    def test_preserves_conditional_assumptions(self):
        independence = {
            "conditionalSpaces": [
                {"space": "S000147", "assumptions": ["CH", "not CH", "MA"]},
                {"space": "S000147", "assumptions": ["CH", "GCH"]},
            ]
        }
        output = self.render(
            {"P000001": True, "P000002": True}, independence
        )

        self.assertIn(
            "theorem S147_P3 [PiBase.ContinuumHypothesis] "
            "[PiBase.NotContinuumHypothesis] [PiBase.MartinsAxiom] "
            "[PiBase.GeneralizedContinuumHypothesis] : P3 PiBase.S147 :=",
            output,
        )
        self.assertIn(
            "assumptions [continuumHypothesis, notContinuumHypothesis, "
            "martinsAxiom, generalizedContinuumHypothesis]",
            output,
        )
        self.assertEqual(output.count("continuumHypothesis"), 1)

    def test_never_emits_proof_placeholders(self):
        output = self.render({"P000001": True, "P000002": True})
        lowered = output.lower()
        for forbidden in ("sorry", "admit", "axiom", "placeholder"):
            self.assertNotIn(forbidden, lowered)


class CliTests(unittest.TestCase):
    def make_fixture(self, directory):
        root = Path(directory)
        catalog = {
            "properties": [
                {"uid": "P000001", "name": "first"},
                {"uid": "P000002", "name": "second"},
            ],
            "spaces": [{"uid": "S000003", "name": "fixture"}],
            "traits": [
                {"space": "S000003", "property": "P000001", "value": True}
            ],
            "theorems": [
                implication("T000001", [atom("P000001")], atom("P000002"))
            ],
        }
        catalog_path = root / "catalog.json"
        catalog_path.write_text(json.dumps(catalog), encoding="utf-8")
        independence_path = root / "independence.json"
        independence_path.write_text("{}", encoding="utf-8")
        declarations = {
            "Properties/P1/Bundled.lean": "def P1\n",
            "Properties/P2/Bundled.lean": "def P2\n",
            "Theorems/T1/Theorem.lean": "theorem T1 : P1 ≤ P2 := by sorry\n",
        }
        for relative_path, content in declarations.items():
            source = root / "lean" / "PiBaseLean" / relative_path
            source.parent.mkdir(parents=True)
            source.write_text(content, encoding="utf-8")
        lemmas = root / "spaces" / "S3" / "Lemmas.lean"
        lemmas.parent.mkdir(parents=True)
        lemmas.write_text("handwritten direct proofs\n", encoding="utf-8")
        return (
            catalog_path,
            independence_path,
            root / "lean",
            root / "spaces",
            lemmas,
            lemmas.with_name("Generated.lean"),
        )

    def run_cli(self, *args):
        return subprocess.run(
            [sys.executable, str(SCRIPT), *map(str, args)],
            text=True,
            capture_output=True,
            check=False,
        )

    def common_args(self, fixture):
        catalog, independence, lean_root, generated_root, _, _ = fixture
        return (
            "--catalog", catalog,
            "--independence", independence,
            "--lean-root", lean_root,
            "--generated-root", generated_root,
        )

    def test_write_is_idempotent_and_never_writes_lemmas(self):
        with tempfile.TemporaryDirectory() as directory:
            fixture = self.make_fixture(directory)
            _, _, _, _, lemmas, generated = fixture
            common = self.common_args(fixture)
            lemmas_content = lemmas.read_text(encoding="utf-8")
            lemmas_mtime = lemmas.stat().st_mtime_ns

            first = self.run_cli("--write", *common, "S3")
            self.assertEqual(first.returncode, 0, first.stderr)
            first_content = generated.read_text(encoding="utf-8")
            self.assertIn(GEN_TRAITS.GENERATED_HEADER, first_content)
            self.assertIn("theorem S3_P2", first_content)
            self.assertEqual(lemmas.read_text(encoding="utf-8"), lemmas_content)
            self.assertEqual(lemmas.stat().st_mtime_ns, lemmas_mtime)

            first_mtime = generated.stat().st_mtime_ns
            second = self.run_cli("--write", *common, "S3")
            self.assertEqual(second.returncode, 0, second.stderr)
            self.assertIn("unchanged:", second.stdout)
            self.assertEqual(generated.read_text(encoding="utf-8"), first_content)
            self.assertEqual(generated.stat().st_mtime_ns, first_mtime)

            current = self.run_cli("--check", *common, "S3")
            self.assertEqual(current.returncode, 0, current.stderr)
            self.assertIn("current:", current.stdout)

    def test_check_reports_missing_and_stale_without_writing(self):
        with tempfile.TemporaryDirectory() as directory:
            fixture = self.make_fixture(directory)
            _, _, _, _, _, generated = fixture
            common = self.common_args(fixture)

            missing = self.run_cli("--check", *common, "S3")
            self.assertEqual(missing.returncode, 1)
            self.assertIn("missing:", missing.stdout)
            self.assertFalse(generated.exists())

            self.assertEqual(self.run_cli("--write", *common, "S3").returncode, 0)
            generated.write_text("stale\n", encoding="utf-8")
            stale = self.run_cli("--check", *common, "S3")
            self.assertEqual(stale.returncode, 1)
            self.assertIn("stale:", stale.stdout)
            self.assertEqual(generated.read_text(encoding="utf-8"), "stale\n")

    def test_emit_outputs_complete_module_without_writing(self):
        with tempfile.TemporaryDirectory() as directory:
            fixture = self.make_fixture(directory)
            _, _, _, _, lemmas, generated = fixture
            result = self.run_cli("--emit", *self.common_args(fixture), "S3")

            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertTrue(result.stdout.startswith("module\n\n"))
            self.assertIn(GEN_TRAITS.GENERATED_HEADER, result.stdout)
            self.assertIn("public import PiBaseLean.Spaces.S3.Lemmas", result.stdout)
            self.assertFalse(generated.exists())
            self.assertEqual(
                lemmas.read_text(encoding="utf-8"), "handwritten direct proofs\n"
            )

    def test_write_requires_existing_numbered_lemmas_file(self):
        with tempfile.TemporaryDirectory() as directory:
            fixture = self.make_fixture(directory)
            _, _, _, _, lemmas, generated = fixture
            lemmas.unlink()
            result = self.run_cli("--write", *self.common_args(fixture), "S3")

            self.assertEqual(result.returncode, 1)
            self.assertIn("does not exist", result.stderr)
            self.assertFalse(generated.exists())

    def test_check_requires_existing_numbered_lemmas_file(self):
        with tempfile.TemporaryDirectory() as directory:
            fixture = self.make_fixture(directory)
            _, _, _, _, lemmas, generated = fixture
            common = self.common_args(fixture)
            self.assertEqual(self.run_cli("--write", *common, "S3").returncode, 0)
            lemmas.unlink()

            result = self.run_cli("--check", *common, "S3")

            self.assertEqual(result.returncode, 1)
            self.assertIn(f"missing: {lemmas.resolve()}", result.stdout)
            self.assertTrue(generated.exists())


if __name__ == "__main__":
    unittest.main()

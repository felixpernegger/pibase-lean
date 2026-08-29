import copy
import json
import subprocess
import sys
import unittest
from pathlib import Path
from unittest.mock import patch

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))

from classification_audit_contract import (  # noqa: E402
    ClassificationAuditContractError,
    catalogue_property_ids,
    parse_classification_audit,
    validate_classification_audit,
)
from build_dashboard_data import is_felix_commit, run_classification_audit  # noqa: E402


PROPERTIES = [{"uid": f"P{index:06d}"} for index in range(1, 247)]
VALID_REPORT = {
    "schemaVersion": 1,
    "scope": "positive-ordered-distinct",
    "planDeclaration": "PiBase.Formal.piBaseClassificationPlan",
    "goalDeclaration": "PiBase.Formal.PiBasePositiveImplicationGoal",
    "propertyIds": list(range(1, 247)),
    "propertyCount": 246,
    "pairCount": 60_270,
    "statuses": {"proved": 0, "refuted": 0, "variesUnder": 0, "open": 60_270},
    "sound": True,
    "complete": False,
}


class ClassificationAuditContractTests(unittest.TestCase):
    def test_accepts_current_open_target(self) -> None:
        validate_classification_audit(VALID_REPORT, PROPERTIES)

    def test_declaration_fields_are_required(self) -> None:
        report = copy.deepcopy(VALID_REPORT)
        report.pop("planDeclaration")
        with self.assertRaisesRegex(ClassificationAuditContractError, "missing fields"):
            validate_classification_audit(report, PROPERTIES)

    def test_rejects_catalogue_reordering_even_when_length_is_unchanged(self) -> None:
        properties = copy.deepcopy(PROPERTIES)
        properties[0], properties[1] = properties[1], properties[0]
        with self.assertRaisesRegex(ClassificationAuditContractError, "must be P000001"):
            validate_classification_audit(VALID_REPORT, properties)

    def test_rejects_lean_property_id_reordering(self) -> None:
        report = copy.deepcopy(VALID_REPORT)
        report["propertyIds"][0], report["propertyIds"][1] = (
            report["propertyIds"][1],
            report["propertyIds"][0],
        )
        with self.assertRaisesRegex(ClassificationAuditContractError, "propertyIds"):
            validate_classification_audit(report, PROPERTIES)

    def test_rejects_wrong_pair_count(self) -> None:
        report = copy.deepcopy(VALID_REPORT)
        report["pairCount"] -= 1
        with self.assertRaisesRegex(ClassificationAuditContractError, "pairCount"):
            validate_classification_audit(report, PROPERTIES)

    def test_rejects_incomplete_status_partition(self) -> None:
        report = copy.deepcopy(VALID_REPORT)
        report["statuses"]["proved"] = 1
        with self.assertRaisesRegex(ClassificationAuditContractError, "do not sum"):
            validate_classification_audit(report, PROPERTIES)

    def test_rejects_complete_flag_with_open_pairs(self) -> None:
        report = copy.deepcopy(VALID_REPORT)
        report["complete"] = True
        with self.assertRaisesRegex(ClassificationAuditContractError, "complete flag"):
            validate_classification_audit(report, PROPERTIES)

    def test_rejects_report_without_proved_soundness(self) -> None:
        report = copy.deepcopy(VALID_REPORT)
        report["sound"] = False
        with self.assertRaisesRegex(ClassificationAuditContractError, "soundness certificate"):
            validate_classification_audit(report, PROPERTIES)

    def test_rejects_unknown_fields_and_declaration_names(self) -> None:
        unknown = copy.deepcopy(VALID_REPORT)
        unknown["unexpected"] = 1
        with self.assertRaisesRegex(ClassificationAuditContractError, "unknown fields"):
            validate_classification_audit(unknown, PROPERTIES)

        wrong_declaration = copy.deepcopy(VALID_REPORT)
        wrong_declaration["goalDeclaration"] = "PiBase.Formal.WrongGoal"
        with self.assertRaisesRegex(ClassificationAuditContractError, "goalDeclaration"):
            validate_classification_audit(wrong_declaration, PROPERTIES)

    def test_catalogue_is_exactly_p1_through_p246(self) -> None:
        self.assertEqual(catalogue_property_ids(PROPERTIES), list(range(1, 247)))
        with self.assertRaisesRegex(ClassificationAuditContractError, "exactly the ordered IDs"):
            validate_classification_audit(
                {
                    **VALID_REPORT,
                    "propertyIds": list(range(1, 246)),
                    "propertyCount": 245,
                    "pairCount": 59_780,
                    "statuses": {
                        "proved": 0,
                        "refuted": 0,
                        "variesUnder": 0,
                        "open": 59_780,
                    },
                },
                PROPERTIES[:-1],
            )

    def test_repository_catalogue_matches_the_lean_audit_contract(self) -> None:
        with (ROOT / "data" / "pibase.json").open(encoding="utf-8") as handle:
            properties = json.load(handle)["properties"]
        validate_classification_audit(VALID_REPORT, properties)

    @patch("build_dashboard_data.subprocess.run")
    def test_runner_accepts_json_only_stdout(self, run) -> None:
        run.return_value = subprocess.CompletedProcess(
            ["lake", "exe", "classificationAudit"],
            0,
            stdout=json.dumps(VALID_REPORT),
            stderr="",
        )
        self.assertEqual(run_classification_audit(PROPERTIES), VALID_REPORT)

    @patch("build_dashboard_data.subprocess.run")
    def test_runner_rejects_non_json_stdout(self, run) -> None:
        run.return_value = subprocess.CompletedProcess(
            ["lake", "exe", "classificationAudit"],
            0,
            stdout="build log\n" + json.dumps(VALID_REPORT),
            stderr="",
        )
        with self.assertRaisesRegex(SystemExit, "exactly one JSON value"):
            run_classification_audit(PROPERTIES)

    @patch("build_dashboard_data.subprocess.run")
    def test_runner_rejects_nonzero_exit(self, run) -> None:
        run.return_value = subprocess.CompletedProcess(
            ["lake", "exe", "classificationAudit"],
            1,
            stdout="",
            stderr="audit failed",
        )
        with self.assertRaisesRegex(SystemExit, "audit failed"):
            run_classification_audit(PROPERTIES)

    def test_parser_rejects_duplicate_json_fields(self) -> None:
        with self.assertRaisesRegex(ClassificationAuditContractError, "duplicate field 'open'"):
            parse_classification_audit('{"open":60270,"open":0}')

    @patch("build_dashboard_data.git")
    def test_canonical_remote_tracking_ref_counts_as_provenance(self, git) -> None:
        def result(*args: str) -> str:
            if args == ("remote",):
                return "origin"
            if args == ("remote", "get-url", "origin"):
                return "https://github.com/felixpernegger/pibase-lean.git"
            if args == (
                "for-each-ref",
                "--format=%(refname)",
                "--points-at=HEAD",
                "refs/remotes/origin",
            ):
                return "refs/remotes/origin/pull/1322/merge"
            return ""

        git.side_effect = result
        self.assertTrue(is_felix_commit())

    @patch("build_dashboard_data.git")
    def test_rejects_lookalike_github_host(self, git) -> None:
        def result(*args: str) -> str:
            if args == ("remote",):
                return "origin"
            if args == ("remote", "get-url", "origin"):
                return "https://github.com.evil.example/felixpernegger/pibase-lean.git"
            return "refs/remotes/origin/main"

        git.side_effect = result
        self.assertFalse(is_felix_commit())

    @patch("build_dashboard_data.git")
    def test_rejects_unscoped_pull_ref(self, git) -> None:
        def result(*args: str) -> str:
            if args == ("remote",):
                return "origin"
            if args == ("remote", "get-url", "origin"):
                return "git@github.com:felixpernegger/pibase-lean.git"
            if args[-1] == "refs/remotes/pull":
                return "refs/remotes/pull/1322/merge"
            return ""

        git.side_effect = result
        self.assertFalse(is_felix_commit())


if __name__ == "__main__":
    unittest.main()

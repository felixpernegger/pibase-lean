from __future__ import annotations

import copy
import json
import sys
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))

from space_audit_contract import (  # noqa: E402
    PublishedAuditContractError,
    expected_trait_contract,
    validate_published_audit,
)


def catalog() -> dict:
    return {
        "properties": [
            {"uid": "P000001", "name": "First"},
            {"uid": "P000002", "name": "Second"},
        ],
        "spaces": [{"uid": "S000001", "name": "Test space"}],
        "traits": [
            {"space": "S000001", "property": "P000001", "value": True}
        ],
        "theorems": [
            {
                "uid": "T000001",
                "when": {"kind": "atom", "property": "P000001", "value": True},
                "then": {"kind": "atom", "property": "P000002", "value": True},
            }
        ],
    }


def trait(property_id: str, provenance: str) -> dict:
    short_property = f"P{int(property_id[1:])}"
    return {
        "propertyId": property_id,
        "name": "First" if property_id == "P000001" else "Second",
        "expected": True,
        "polarity": True,
        "certificate": f"PiBase.Formal.S1_{short_property}",
        "provenance": provenance,
    }


def report() -> dict:
    return {
        "scope": ["S000001"],
        "summary": {"traits": 2},
        "spaces": [
            {
                "spaceId": "S000001",
                "catalogName": "Test space",
                "presentation": {
                    "carrier": "PiBase.S1",
                    "canonicalHomeomorph": "PiBase.S1_canonicalHomeomorph",
                },
                "traits": [
                    trait("P000001", "direct"),
                    trait("P000002", "derived"),
                ],
            }
        ],
    }


class PublishedSpaceAuditContractTest(unittest.TestCase):
    def setUp(self) -> None:
        self.temporary = tempfile.TemporaryDirectory()
        self.root = Path(self.temporary.name)
        for number in (1, 2):
            path = self.root / "PiBaseLean" / "Properties" / f"P{number}"
            path.mkdir(parents=True)
            (path / "Bundled.lean").write_text(
                f"def P{number} := True\n", encoding="utf-8"
            )
        theorem = self.root / "PiBaseLean" / "Theorems" / "T1"
        theorem.mkdir(parents=True)
        (theorem / "Theorem.lean").write_text(
            "theorem T1 : P1 ≤ P2 := by trivial\n", encoding="utf-8"
        )

    def tearDown(self) -> None:
        self.temporary.cleanup()

    def validate(self, value: dict) -> None:
        validate_published_audit(
            value, catalog(), {}, self.root, ("S000001",)
        )

    def test_accepts_exact_direct_and_generated_contract(self) -> None:
        self.validate(report())

    def test_rejects_omitted_or_renamed_generated_certificate(self) -> None:
        missing = report()
        missing["spaces"][0]["traits"].pop()
        missing["summary"]["traits"] = 1
        with self.assertRaisesRegex(
            PublishedAuditContractError, "certificate set mismatch"
        ):
            self.validate(missing)

        renamed = copy.deepcopy(report())
        renamed["spaces"][0]["traits"][1]["certificate"] = "Fake.certificate"
        with self.assertRaisesRegex(
            PublishedAuditContractError, "certificate mismatch"
        ):
            self.validate(renamed)

    def test_rejects_each_identity_and_trait_contract_mutation(self) -> None:
        mutations = {
            "scope": lambda value: value.update(scope=["S000002"]),
            "carrier": lambda value: value["spaces"][0]["presentation"].update(
                carrier="Fake.Carrier"
            ),
            "homeomorph": lambda value: value["spaces"][0]["presentation"].update(
                canonicalHomeomorph="Fake.homeomorph"
            ),
            "extra trait": lambda value: value["spaces"][0]["traits"].append(
                {**trait("P000002", "derived"), "propertyId": "P000003"}
            ),
            "duplicate trait": lambda value: value["spaces"][0]["traits"].append(
                copy.deepcopy(value["spaces"][0]["traits"][1])
            ),
            "name": lambda value: value["spaces"][0]["traits"][1].update(
                name="Forged"
            ),
            "polarity": lambda value: value["spaces"][0]["traits"][1].update(
                expected=False, polarity=False
            ),
            "provenance": lambda value: value["spaces"][0]["traits"][1].update(
                provenance="direct"
            ),
        }
        for label, mutate in mutations.items():
            with self.subTest(label=label):
                value = report()
                mutate(value)
                with self.assertRaises(PublishedAuditContractError):
                    self.validate(value)

    def test_real_pilot_contract_remains_locked_to_86_certificates(self) -> None:
        with (ROOT / "data" / "pibase.json").open(encoding="utf-8") as handle:
            real_catalog = json.load(handle)
        with (ROOT / "data" / "independence.json").open(encoding="utf-8") as handle:
            independence = json.load(handle)
        expected = expected_trait_contract(
            real_catalog,
            independence,
            ROOT,
            ("S000001", "S000004", "S000010", "S000189"),
        )
        self.assertEqual(
            {space_id: len(rows) for space_id, rows in expected.items()},
            {"S000001": 34, "S000004": 7, "S000010": 13, "S000189": 32},
        )


if __name__ == "__main__":
    unittest.main()

#!/usr/bin/env python3
"""Validate the Lean-exported positive implication-classification target."""

from __future__ import annotations

import json
from collections.abc import Mapping, Sequence
from typing import Any


class ClassificationAuditContractError(ValueError):
    """Raised when the Lean audit does not describe this dashboard catalogue."""


REQUIRED_FIELDS = {
    "schemaVersion",
    "scope",
    "planDeclaration",
    "goalDeclaration",
    "propertyIds",
    "propertyCount",
    "pairCount",
    "statuses",
    "sound",
    "complete",
}
STATUS_FIELDS = {"proved", "refuted", "variesUnder", "open"}
EXPECTED_SCOPE = "positive-ordered-distinct"
EXPECTED_PLAN_DECLARATION = "PiBase.Formal.piBaseClassificationPlan"
EXPECTED_GOAL_DECLARATION = "PiBase.Formal.PiBasePositiveImplicationGoal"


def _is_int(value: Any) -> bool:
    return isinstance(value, int) and not isinstance(value, bool)


def parse_classification_audit(raw: str) -> Mapping[str, Any]:
    """Parse exactly one JSON object and reject duplicate object keys."""
    def unique_object(pairs: list[tuple[str, Any]]) -> dict[str, Any]:
        result: dict[str, Any] = {}
        for key, value in pairs:
            if key in result:
                raise ClassificationAuditContractError(
                    f"classification audit contains duplicate field {key!r}"
                )
            result[key] = value
        return result

    try:
        report = json.loads(raw, object_pairs_hook=unique_object)
    except json.JSONDecodeError as error:
        raise ClassificationAuditContractError(
            f"classification audit did not emit exactly one JSON value: {error}"
        ) from error
    if not isinstance(report, Mapping):
        raise ClassificationAuditContractError("classification audit root must be an object")
    return report


def catalogue_property_ids(properties: Sequence[Mapping[str, Any]]) -> list[int]:
    """Read canonical numeric property IDs without accepting aliases or reordering."""
    result: list[int] = []
    for index, entry in enumerate(properties, start=1):
        uid = entry.get("uid")
        expected_uid = f"P{index:06d}"
        if uid != expected_uid:
            raise ClassificationAuditContractError(
                f"property {index} must be {expected_uid}, got {uid!r}"
            )
        result.append(index)
    return result


def validate_classification_audit(
    report: Mapping[str, Any], properties: Sequence[Mapping[str, Any]]
) -> None:
    """Fail unless a Lean report exactly matches the dashboard's ordered catalogue."""
    if not isinstance(report, Mapping):
        raise ClassificationAuditContractError("classification audit root must be an object")
    fields = set(report)
    missing = REQUIRED_FIELDS - fields
    extra = fields - REQUIRED_FIELDS
    if missing:
        raise ClassificationAuditContractError(
            "classification audit is missing fields: " + ", ".join(sorted(missing))
        )
    if extra:
        raise ClassificationAuditContractError(
            "classification audit has unknown fields: " + ", ".join(sorted(extra))
        )

    if report["schemaVersion"] != 1 or not _is_int(report["schemaVersion"]):
        raise ClassificationAuditContractError("classification audit schemaVersion must be 1")
    if report["scope"] != EXPECTED_SCOPE:
        raise ClassificationAuditContractError(
            f"classification audit scope must be {EXPECTED_SCOPE!r}"
        )

    expected_ids = catalogue_property_ids(properties)
    if expected_ids != list(range(1, 247)):
        raise ClassificationAuditContractError(
            "dashboard catalogue must contain exactly the ordered IDs P000001 through P000246"
        )
    property_ids = report["propertyIds"]
    if not isinstance(property_ids, list) or not all(_is_int(item) for item in property_ids):
        raise ClassificationAuditContractError("classification audit propertyIds must be integers")
    if property_ids != expected_ids:
        raise ClassificationAuditContractError(
            "classification audit propertyIds do not exactly match data/pibase.json"
        )

    property_count = report["propertyCount"]
    if not _is_int(property_count) or property_count != len(expected_ids):
        raise ClassificationAuditContractError(
            f"classification audit propertyCount must be {len(expected_ids)}"
        )
    pair_count = report["pairCount"]
    expected_pair_count = property_count * (property_count - 1)
    if not _is_int(pair_count) or pair_count != expected_pair_count:
        raise ClassificationAuditContractError(
            f"classification audit pairCount must be {expected_pair_count}"
        )

    statuses = report["statuses"]
    if not isinstance(statuses, Mapping) or set(statuses) != STATUS_FIELDS:
        raise ClassificationAuditContractError(
            "classification audit statuses must be exactly proved, refuted, variesUnder, and open"
        )
    if not all(_is_int(value) and value >= 0 for value in statuses.values()):
        raise ClassificationAuditContractError(
            "classification audit status counts must be non-negative integers"
        )
    if sum(statuses.values()) != pair_count:
        raise ClassificationAuditContractError(
            "classification audit status counts do not sum to pairCount"
        )

    if report["sound"] is not True:
        raise ClassificationAuditContractError(
            "classification audit must be generated from a proved soundness certificate"
        )

    complete = report["complete"]
    if not isinstance(complete, bool):
        raise ClassificationAuditContractError("classification audit complete must be a boolean")
    if complete != (statuses["open"] == 0):
        raise ClassificationAuditContractError(
            "classification audit complete flag disagrees with its open count"
        )

    declarations = {
        "planDeclaration": EXPECTED_PLAN_DECLARATION,
        "goalDeclaration": EXPECTED_GOAL_DECLARATION,
    }
    for field, expected in declarations.items():
        if report[field] != expected:
            raise ClassificationAuditContractError(
                f"classification audit {field} must be {expected!r}"
            )

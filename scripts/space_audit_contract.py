#!/usr/bin/env python3
"""Bind a published space-audit report to the current generated Lean contract."""

from __future__ import annotations

from collections.abc import Mapping, Sequence
from pathlib import Path
from typing import Any

from gen_traits import GenerationContext, close, short_uid, theorem_name


class PublishedAuditContractError(ValueError):
    """Raised when a report is valid JSON but not the report this checkout expects."""


def _unique_catalog_map(
    entries: Sequence[Mapping[str, Any]], kind: str
) -> dict[str, Mapping[str, Any]]:
    result: dict[str, Mapping[str, Any]] = {}
    for entry in entries:
        uid = entry.get("uid")
        if not isinstance(uid, str) or not uid:
            raise PublishedAuditContractError(f"{kind} catalog entry has no UID")
        if uid in result:
            raise PublishedAuditContractError(f"duplicate {kind} catalog UID: {uid}")
        result[uid] = entry
    return result


def expected_trait_contract(
    catalog: Mapping[str, Any],
    independence: Mapping[str, Any],
    lean_root: Path | str,
    scope: Sequence[str],
) -> dict[str, dict[str, dict[str, Any]]]:
    """Recompute the exact direct and generated certificate contract."""
    context = GenerationContext(
        catalog=catalog,
        lean_root=Path(lean_root).resolve(),
        independence=independence,
    )
    property_catalog = _unique_catalog_map(catalog["properties"], "property")
    seeds = context.seeds
    theorems = context.available_theorems
    available_properties = context.available_properties
    result: dict[str, dict[str, dict[str, Any]]] = {}

    for space_id in scope:
        if space_id not in seeds:
            raise PublishedAuditContractError(
                f"published space has no direct catalog traits: {space_id}"
            )
        known, derivations, order = close(
            seeds[space_id], theorems, available_properties
        )
        rows: dict[str, dict[str, Any]] = {}
        for property_id in order:
            if property_id not in property_catalog:
                raise PublishedAuditContractError(
                    f"generated trait references an unknown property: {property_id}"
                )
            value = known[property_id]
            rows[property_id] = {
                "name": property_catalog[property_id]["name"],
                "expected": value,
                "polarity": value,
                "certificate": (
                    "PiBase.Formal."
                    + theorem_name(space_id, property_id, value)
                ),
                "provenance": (
                    "direct"
                    if derivations[property_id][0] == "direct"
                    else "derived"
                ),
            }
        result[space_id] = rows
    return result


def validate_published_audit(
    report: Mapping[str, Any],
    catalog: Mapping[str, Any],
    independence: Mapping[str, Any],
    lean_root: Path | str,
    scope: Sequence[str],
) -> None:
    """Reject a successful-looking report that diverges from this checkout."""
    expected_scope = list(scope)
    if report.get("scope") != expected_scope:
        raise PublishedAuditContractError(
            f"scope mismatch: expected {expected_scope}, got {report.get('scope')}"
        )

    space_catalog = _unique_catalog_map(catalog["spaces"], "space")
    expected_traits = expected_trait_contract(
        catalog, independence, lean_root, expected_scope
    )
    report_spaces = report.get("spaces")
    if not isinstance(report_spaces, list):
        raise PublishedAuditContractError("report spaces are not an array")
    actual_spaces = {entry.get("spaceId"): entry for entry in report_spaces}
    if len(actual_spaces) != len(report_spaces) or set(actual_spaces) != set(expected_scope):
        raise PublishedAuditContractError(
            "report spaces do not exactly match the published scope"
        )

    for space_id in expected_scope:
        space = actual_spaces[space_id]
        if space_id not in space_catalog:
            raise PublishedAuditContractError(
                f"published space is absent from the catalog: {space_id}"
            )
        expected_name = space_catalog[space_id]["name"]
        if space.get("catalogName") != expected_name:
            raise PublishedAuditContractError(
                f"catalog name mismatch for {space_id}: expected {expected_name!r}"
            )

        short = short_uid(space_id)
        presentation = space.get("presentation", {})
        expected_carrier = f"PiBase.{short}"
        expected_homeomorph = f"{expected_carrier}_canonicalHomeomorph"
        if presentation.get("carrier") != expected_carrier:
            raise PublishedAuditContractError(
                f"carrier mismatch for {space_id}: expected {expected_carrier}"
            )
        if presentation.get("canonicalHomeomorph") != expected_homeomorph:
            raise PublishedAuditContractError(
                f"canonical homeomorphism mismatch for {space_id}: "
                f"expected {expected_homeomorph}"
            )

        trait_entries = space.get("traits")
        if not isinstance(trait_entries, list):
            raise PublishedAuditContractError(f"traits are not an array for {space_id}")
        actual_traits = {entry.get("propertyId"): entry for entry in trait_entries}
        expected = expected_traits[space_id]
        if len(actual_traits) != len(trait_entries) or set(actual_traits) != set(expected):
            missing = sorted(set(expected) - set(actual_traits))
            extra = sorted(set(actual_traits) - set(expected))
            raise PublishedAuditContractError(
                f"certificate set mismatch for {space_id}: "
                f"missing {missing}, extra {extra}"
            )
        for property_id, expected_row in expected.items():
            row = actual_traits[property_id]
            for field, expected_value in expected_row.items():
                if row.get(field) != expected_value:
                    raise PublishedAuditContractError(
                        f"{space_id}/{property_id} {field} mismatch: "
                        f"expected {expected_value!r}, got {row.get(field)!r}"
                    )

    expected_total = sum(len(rows) for rows in expected_traits.values())
    if report.get("summary", {}).get("traits") != expected_total:
        raise PublishedAuditContractError(
            f"trait total mismatch: expected {expected_total}, "
            f"got {report.get('summary', {}).get('traits')}"
        )

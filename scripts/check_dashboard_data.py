#!/usr/bin/env python3
"""Fail when generated dashboard artifacts disagree with their manifest."""

from __future__ import annotations

import hashlib
import json
import re
from collections import Counter
from pathlib import Path

from run_space_audit import (
    REQUIRED_SPACE_AUDIT_SCOPE,
    load_audit_artifact,
    normalized_json,
)
from space_audit_contract import (
    PublishedAuditContractError,
    validate_published_audit,
)

ROOT = Path(__file__).resolve().parent.parent
PUBLIC = ROOT / "dashboard" / "public"
DATA = PUBLIC / "data"


def load(path: Path):
    with path.open(encoding="utf-8") as handle:
        return json.load(handle)


def require(condition: bool, message: str) -> None:
    if not condition:
        raise SystemExit(f"dashboard integrity error: {message}")


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def check_review(
    kind: str, expected: int, source_prefix: str, source_commit: str
) -> dict[str, dict]:
    def has_expected_source(entry: dict) -> bool:
        if kind == "spaces" and not entry["spaceAudit"]["targeted"]:
            return entry["sourceUrl"] == ""
        return entry["sourceUrl"].startswith(source_prefix)

    index = load(DATA / f"review-{kind}.json")
    require(index["schemaVersion"] == 2, f"unexpected {kind} review index schema version")
    require(index["kind"] == kind, f"{kind} review index has the wrong kind")
    require(
        index["sourceCommit"] == source_commit,
        f"{kind} review index has the wrong source commit",
    )
    entries = index["entries"]
    require(len(entries) == expected, f"{kind} review index has {len(entries)} entries, expected {expected}")
    require(len({entry["id"] for entry in entries}) == expected, f"{kind} review index has duplicate IDs")
    require(
        all(has_expected_source(entry) for entry in entries),
        f"{kind} review index contains a non-canonical source link",
    )
    if kind == "properties":
        require(
            all("wellDefinedPlaceholders" in entry["leanStatus"] for entry in entries),
            "property review index is missing well-definedness audit data",
        )
    if kind == "spaces":
        require(
            all("spaceAudit" in entry for entry in entries),
            "space review index is missing structured audit data",
        )
    chunk_entries: dict[str, dict] = {}
    chunk_numbers: dict[str, int] = {}
    for chunk_number, relative in enumerate(index["chunks"]):
        path = PUBLIC / relative
        require(path.exists(), f"missing review chunk {relative}")
        payload = load(path)
        require(payload["schemaVersion"] == 2, f"unexpected review schema version in {relative}")
        require(payload["kind"] == kind, f"review chunk has the wrong kind in {relative}")
        require(
            payload["sourceCommit"] == source_commit,
            f"review chunk has the wrong source commit in {relative}",
        )
        require(payload["chunk"] == chunk_number, f"review chunk number mismatch in {relative}")
        require(
            all(has_expected_source(entry) for entry in payload["entries"]),
            f"{relative} contains a non-canonical source link",
        )
        for entry in payload["entries"]:
            require(entry["id"] not in chunk_entries, f"{kind} review chunks contain duplicate IDs")
            chunk_entries[entry["id"]] = entry
            chunk_numbers[entry["id"]] = chunk_number
    require(set(chunk_entries) == {entry["id"] for entry in entries}, f"{kind} review chunks do not match their index")
    require(all(0 <= entry["chunk"] < len(index["chunks"]) for entry in entries), f"{kind} review entry has an invalid chunk")
    require(
        all(chunk_numbers[entry["id"]] == entry["chunk"] for entry in entries),
        f"{kind} review index points an entry at the wrong chunk",
    )
    require(
        all(
            entry["sourceUrl"] == chunk_entries[entry["id"]]["sourceUrl"]
            for entry in entries
        ),
        f"{kind} review index source links disagree with their chunks",
    )
    if kind == "spaces":
        for entry in entries:
            chunk_entry = chunk_entries[entry["id"]]
            require(
                entry["leanStatus"] == chunk_entry["leanStatus"]
                and entry["spaceAudit"] == chunk_entry["spaceAudit"],
                f"space review index disagrees with its chunk for {entry['id']}",
            )
            require(
                "generatedCode" in chunk_entry,
                f"space review chunk is missing generated certificates for {entry['id']}",
            )
    return chunk_entries


def main() -> None:
    manifest = load(DATA / "dashboard.json")
    catalog = load(ROOT / "data" / "pibase.json")
    canonical_repo = "https://github.com/felixpernegger/pibase-lean"
    require(manifest["schemaVersion"] == 5, "unexpected dashboard schema version")
    require(manifest["project"]["repoUrl"] == canonical_repo, "project repository is not Felix's repository")
    require(
        manifest["project"]["repositoryLabel"] == "felixpernegger/pibase-lean",
        "project repository label is not canonical",
    )
    require(
        "github.com/Deicyde/pibase-lean" not in json.dumps(manifest),
        "dashboard manifest contains a fork source link",
    )
    source_prefix = f"{canonical_repo}/blob/{manifest['source']['commit']}/"
    require(
        re.fullmatch(r"[0-9a-f]{40}", manifest["source"]["commit"]) is not None,
        "Lean source commit is not an exact Git revision",
    )
    size = manifest["graph"]["size"]
    outcomes = (DATA / "outcomes.bin").read_bytes()
    formalized_outcomes = (DATA / "formalized-outcomes.bin").read_bytes()
    witness_bytes = (DATA / "witnesses.bin").read_bytes()
    require(len(manifest["properties"]) == size, "property list does not match graph size")
    require(len(outcomes) == size * size, "outcome matrix dimensions are invalid")
    require(len(formalized_outcomes) == size * size, "formalized outcome matrix dimensions are invalid")
    require(len(witness_bytes) == size * size * 2, "witness matrix dimensions are invalid")

    histogram = Counter(outcomes)
    expected = manifest["graph"]["counts"]
    require(histogram[0] == size, "diagonal cell count is invalid")
    for code, key in ((1, "explicitTrue"), (2, "derivedTrue"), (3, "false"), (4, "axiomDependent"), (5, "unclassified")):
        require(histogram[code] == expected.get(key, 0), f"{key} count disagrees with outcome matrix")
    require(sum(histogram.values()) == size * size, "outcome matrix contains invalid status bytes")
    require(manifest["graph"]["statusCodes"].get("4") == "axiom-dependent", "status code 4 is not axiom-dependent")
    require(manifest["graph"]["statusCodes"].get("5") == "unclassified", "status code 5 is not unclassified")

    formalized_histogram = Counter(formalized_outcomes)
    formalized_counts = manifest["graph"]["formalized"]["counts"]
    require(set(formalized_histogram) <= {0, 1, 2, 5}, "formalized matrix contains invalid status bytes")
    require(formalized_histogram[0] == size, "formalized diagonal cell count is invalid")
    for code, key in ((1, "formalizedDirect"), (2, "formalizedDerived"), (5, "notFormalized")):
        require(
            formalized_histogram[code] == formalized_counts.get(key, 0),
            f"{key} count disagrees with formalized outcome matrix",
        )
    require(
        len(manifest["graph"]["formalized"]["direct"]) == formalized_counts.get("formalizedDirect", 0),
        "formalized direct edge list disagrees with matrix",
    )

    witnesses = [
        int.from_bytes(witness_bytes[index:index + 2], "little")
        for index in range(0, len(witness_bytes), 2)
    ]
    require(max(witnesses, default=0) <= len(manifest["spaces"]), "witness index is out of range")
    require(
        all((value > 0) == (state == 3) for value, state in zip(witnesses, outcomes, strict=True)),
        "witness matrix does not align with false outcomes",
    )
    spaces = manifest["spaces"]
    require(
        all(not spaces[value - 1].get("assumptions") for value in witnesses if value),
        "an axiom-conditional space is being used as an unconditional counterexample",
    )

    node_index = {item["id"]: index for index, item in enumerate(manifest["properties"])}
    formal_frontier = manifest["graph"]["formalized"]["frontier"]
    formal_frontier_pairs = {(item["source"], item["target"]) for item in formal_frontier}
    known_true_count = expected.get("explicitTrue", 0) + expected.get("derivedTrue", 0)
    formalized_true_count = (
        formalized_counts.get("formalizedDirect", 0)
        + formalized_counts.get("formalizedDerived", 0)
    )
    require(
        len(formal_frontier) == known_true_count - formalized_true_count,
        "formalization frontier size disagrees with known pi-Base implications missing from Lean",
    )
    require(
        len(formal_frontier_pairs) == len(formal_frontier),
        "formalization frontier contains duplicate pairs",
    )
    require(
        all(
            formalized_outcomes[node_index[item["source"]] * size + node_index[item["target"]]] == 5
            and outcomes[node_index[item["source"]] * size + node_index[item["target"]]] in {1, 2}
            and item.get("pibaseStatus")
            == (
                "direct"
                if outcomes[node_index[item["source"]] * size + node_index[item["target"]]] == 1
                else "derived"
            )
            for item in formal_frontier
        ),
        "formalization frontier contains a resolved Lean pair or a non-true pi-Base pair",
    )
    require(
        all(
            informal in {1, 2}
            for formal, informal in zip(formalized_outcomes, outcomes, strict=True)
            if formal in {1, 2}
        ),
        "formalized graph contains an implication not recorded as true by pi-Base",
    )
    axiom_dependencies = manifest["graph"]["axiomDependencies"]
    require(
        len(axiom_dependencies) == expected.get("axiomDependent", 0),
        "axiom dependency records disagree with the outcome count",
    )
    dependency_pairs = {(item["source"], item["target"]) for item in axiom_dependencies}
    require(len(dependency_pairs) == len(axiom_dependencies), "axiom dependency records contain duplicate pairs")
    require(
        all(
            item.get("baseTheory")
            and item.get("axioms")
            and outcomes[node_index[item["source"]] * size + node_index[item["target"]]] == 4
            for item in axiom_dependencies
        ),
        "axiom dependency metadata is incomplete or points to a non-dependent cell",
    )

    conditional_evidence = manifest["graph"]["conditionalEvidence"]
    evidence_pairs = {(item["source"], item["target"]): item for item in conditional_evidence}
    require(len(evidence_pairs) == len(conditional_evidence), "conditional evidence contains duplicate pairs")
    space_map = {item["id"]: item for item in spaces}
    require(
        all(
            witness["space"] in space_map
            and space_map[witness["space"]].get("assumptions")
            and witness.get("assumptions")
            for item in conditional_evidence
            for witness in item["witnesses"]
        ),
        "conditional evidence contains an unconditional or unknown space",
    )

    frontier = manifest["frontier"]
    require(
        len(frontier) == expected.get("unclassified", 0),
        "frontier size disagrees with unclassified count",
    )
    require(
        all(outcomes[node_index[item["source"]] * size + node_index[item["target"]]] == 5 for item in frontier),
        "frontier contains a non-open pair",
    )
    require(
        all(
            item.get("conditionalEvidence", False)
            == ((item["source"], item["target"]) in evidence_pairs)
            for item in frontier
        ),
        "frontier conditional-evidence flags disagree with their records",
    )

    summary = manifest["summary"]
    require(sum(manifest["trust"]["properties"].values()) == summary["propertyEntries"], "property trust totals disagree")
    require(
        summary["propertyImplementations"]
        == summary["propertyEntries"] - manifest["trust"]["properties"].get("missing-declaration", 0),
        "canonical property implementation count disagrees with trust ledger",
    )
    require(sum(manifest["trust"]["theorems"].values()) == summary["theoremEntries"], "theorem trust totals disagree")
    require(sum(manifest["trust"]["spaces"].values()) == summary["spaceEntries"], "space trust totals disagree")
    require(
        summary["theoremImplementations"]
        == summary["theoremEntries"]
        - manifest["trust"]["theorems"].get("missing-declaration", 0)
        - manifest["trust"]["theorems"].get("local-debt", 0),
        "implemented theorem count disagrees with trust ledger",
    )
    audit_path = DATA / "space-audit.json"
    require(audit_path.is_file(), "raw space audit artifact is missing")
    audit_result = load_audit_artifact(audit_path).require_success()
    audit = audit_result.report
    try:
        validate_published_audit(
            audit,
            catalog,
            load(ROOT / "data" / "independence.json"),
            ROOT,
            REQUIRED_SPACE_AUDIT_SCOPE,
        )
    except PublishedAuditContractError as error:
        raise SystemExit(f"dashboard integrity error: {error}") from error
    require(
        audit_path.read_text(encoding="utf-8") == normalized_json(audit),
        "raw space audit artifact is not normalized",
    )
    audit_spaces = {entry["spaceId"]: entry for entry in audit["spaces"]}
    require(
        len(audit_spaces) == len(audit["spaces"])
        and audit["scope"] == [entry["spaceId"] for entry in audit["spaces"]],
        "space audit scope and entries are inconsistent",
    )
    require(
        audit["scope"] == list(REQUIRED_SPACE_AUDIT_SCOPE),
        "space audit scope does not match the required published pilot",
    )
    require(
        audit["sourceHashes"]
        == {
            "pibase": sha256(ROOT / "data" / "pibase.json"),
            "independence": sha256(ROOT / "data" / "independence.json"),
        },
        "space audit source hashes do not match the exact catalog bytes",
    )
    require(
        summary["spaceImplementations"]
        == sum(entry["status"] == "implemented" for entry in audit["spaces"]),
        "implemented space count disagrees with implemented audit targets",
    )
    require(
        len(spaces) == summary["spaceTotal"] == summary["spaceEntries"],
        "space manifest, catalog total, and trust ledger are not aligned",
    )
    catalog_space_names = {entry["uid"]: entry["name"] for entry in catalog["spaces"]}
    require(
        len(catalog_space_names) == len(catalog["spaces"]),
        "catalog contains duplicate space IDs",
    )
    property_names = {entry["uid"]: entry["name"] for entry in catalog["properties"]}
    require(
        len(property_names) == len(catalog["properties"]),
        "catalog contains duplicate property IDs",
    )
    catalog_direct: dict[str, dict[str, bool]] = {
        space_id: {} for space_id in catalog_space_names
    }
    for row in catalog["traits"]:
        require(
            row["space"] in catalog_direct and row["property"] in property_names,
            "catalog trait references an unknown space or property",
        )
        direct = catalog_direct[row["space"]]
        require(
            row["property"] not in direct,
            f"catalog contains duplicate direct trait {row['space']}/{row['property']}",
        )
        direct[row["property"]] = row["value"]
    for space_id, audited in audit_spaces.items():
        require(
            audited["catalogName"] == catalog_space_names.get(space_id),
            f"audit catalog name disagrees for {space_id}",
        )
        audited_traits = {row["propertyId"]: row for row in audited["traits"]}
        require(
            len(audited_traits) == len(audited["traits"]),
            f"audit contains duplicate trait properties for {space_id}",
        )
        require(
            set(audited_traits) <= set(property_names),
            f"audit contains an unknown property for {space_id}",
        )
        require(
            all(
                row["name"] == property_names[property_id]
                and row["polarity"] == row["expected"]
                for property_id, row in audited_traits.items()
            ),
            f"audit property names or polarities disagree with the catalog for {space_id}",
        )
        direct = {
            property_id: row["expected"]
            for property_id, row in audited_traits.items()
            if row["provenance"] == "direct"
        }
        require(
            direct == catalog_direct[space_id],
            f"audit direct traits disagree with the catalog for {space_id}",
        )
        require(
            all(
                row["provenance"]
                == ("direct" if property_id in catalog_direct[space_id] else "derived")
                for property_id, row in audited_traits.items()
            ),
            f"audit trait provenance disagrees with the catalog for {space_id}",
        )
    for space in spaces:
        audit_projection = space.get("spaceAudit", {})
        require(
            space["lean"].get("spaceAudit") == audit_projection,
            f"space {space['id']} has inconsistent audit projections",
        )
        audited = audit_spaces.get(space["id"])
        if audited is None:
            require(
                audit_projection == {"status": "not-targeted", "targeted": False},
                f"non-targeted space {space['id']} has an invalid audit projection",
            )
            require(
                not space["lean"]["declarationPresent"]
                and not space["lean"]["dependencyClean"]
                and space["lean"]["status"] == "missing-declaration",
                f"non-targeted space {space['id']} is counted as implemented",
            )
        else:
            require(
                audit_projection == {**audited, "targeted": True},
                f"targeted space {space['id']} disagrees with the raw audit",
            )
            if audited["status"] == "implemented":
                require(
                    space["lean"]["declarationPresent"]
                    and space["lean"]["dependencyClean"]
                    and space["lean"]["status"] == "dependency-clean",
                    f"implemented audit target {space['id']} has an invalid compatibility status",
                )
            else:
                require(
                    not space["lean"]["dependencyClean"]
                    and space["lean"]["status"] in {"missing-declaration", "local-debt"},
                    f"failed audit target {space['id']} is counted as implemented",
                )
    require(summary["propertyImplementations"] <= summary["propertyTotal"], "property coverage exceeds pi-Base total")
    require(summary["theoremImplementations"] <= summary["theoremTotal"], "theorem coverage exceeds pi-Base total")
    require(summary["spaceImplementations"] <= summary["spaceTotal"], "space coverage exceeds pi-Base total")

    source_commit = manifest["source"]["commit"]
    space_review = check_review("spaces", summary["spaceEntries"], source_prefix, source_commit)
    check_review("properties", summary["propertyEntries"], source_prefix, source_commit)
    check_review("theorems", summary["theoremEntries"], source_prefix, source_commit)
    require(
        all(
            space_review[space["id"]]["leanStatus"] == space["lean"]
            and space_review[space["id"]]["spaceAudit"] == space["spaceAudit"]
            for space in spaces
        ),
        "space review data disagrees with the dashboard projection",
    )

    theorem_index = load(DATA / "review-theorems.json")
    theorem_status = {entry["id"]: entry["leanStatus"] for entry in theorem_index["entries"]}
    formal_theorem_ids = {
        theorem_id
        for edge in manifest["graph"]["formalized"]["direct"]
        for theorem_id in edge["theorems"]
    }
    require(
        all(
            theorem_id in theorem_status
            and theorem_status[theorem_id]["declarationPresent"]
            and theorem_status[theorem_id]["localPlaceholders"] == 0
            and theorem_status[theorem_id]["localAxioms"] == 0
            for theorem_id in formal_theorem_ids
        ),
        "formalized graph includes a theorem with local proof debt",
    )

    implications = load(DATA / "implications.json")
    require(
        implications.get("repo") == "felixpernegger/pibase-data",
        "implications payload is not built from Felix's pibase-data",
    )
    literal_count = 2 * len(implications["prop_ids"])
    require(
        len(implications["prop_names"]) == len(implications["prop_ids"]),
        "implications property names are not aligned with ids",
    )
    require(
        len(implications["clauses"]) == len(implications["clause_ids"]),
        "implications clause sources are not aligned with clauses",
    )
    require(
        len(implications["models"]) == len(implications["model_meta"]),
        "implications model metadata is not aligned with models",
    )
    require(
        all(0 <= literal < literal_count for clause in implications["clauses"] for literal in clause),
        "implications clause literal is out of range",
    )
    require(
        all(
            len(model) == len(implications["prop_ids"]) and set(model) <= {"0", "1", "?"}
            for model in implications["models"]
        ),
        "implications payload contains a malformed model",
    )
    require(
        implications["counts"]["unknown"] == len(implications["pairs"]),
        "implications open count disagrees with the pair list",
    )
    require(
        any(artifact["path"] == "data/implications.json" for artifact in manifest["downloads"]),
        "implications payload is not listed as a download",
    )

    questions = load(DATA / "questions.json")
    require(
        questions["open_count"] == len(questions["questions"]),
        "questions worklist count disagrees with its entries",
    )
    require(
        questions["open_count"] == manifest["summary"]["unclassifiedPairs"],
        "questions worklist disagrees with the manifest's unclassified pairs",
    )
    property_ids = {entry["id"] for entry in manifest["properties"]}
    require(
        all(
            item["hypothesis"] in property_ids and item["conclusion"] in property_ids
            for item in questions["questions"]
        ),
        "questions worklist references an unknown property",
    )
    traits = load(DATA / "traits.json")
    property_names = {entry["id"]: entry["name"] for entry in manifest["properties"]}
    catalog_traits: dict[str, list[dict]] = {space_id: [] for space_id in space_map}
    for row in catalog["traits"]:
        catalog_traits[row["space"]].append({
            "property": row["property"],
            "name": property_names.get(row["property"], row["property"]),
            "value": row["value"],
            "status": "asserted",
            "via": None,
        })
    require(
        set(traits) == set(space_map),
        "trait tables do not cover the complete space catalog",
    )
    require(
        all(
            space.startswith("S") and all(row["property"] in property_ids for row in payload["traits"])
            for space, payload in traits.items()
        ),
        "trait tables reference an unknown property",
    )
    for space_id, payload in traits.items():
        audited = audit_spaces.get(space_id)
        if audited is None:
            require(
                payload["traits"] == catalog_traits[space_id],
                f"non-targeted space {space_id} traits are not exact catalog assertions",
            )
            continue
        expected_traits = [
            {
                "property": row["propertyId"],
                "name": row.get("name") or property_names.get(row["propertyId"], row["propertyId"]),
                "value": row["expected"],
                "status": (
                    "proven"
                    if row["status"] == "implemented" and row.get("provenance") == "derived"
                    else "asserted"
                    if row["status"] == "implemented" and row.get("provenance") == "direct"
                    else "derivable"
                ),
                "via": row.get("certificate"),
            }
            for row in audited["traits"]
        ]
        require(
            payload["traits"] == expected_traits,
            f"targeted space {space_id} traits do not come exactly from the audit",
        )
    require(
        all(space_review[space_id]["traits"] == payload["traits"] for space_id, payload in traits.items()),
        "space review traits disagree with the trait artifact",
    )

    require(
        any(artifact["path"] == "data/space-audit.json" for artifact in manifest["downloads"]),
        "raw space audit is not listed as a download",
    )
    for artifact in manifest["downloads"]:
        require((PUBLIC / artifact["path"]).exists(), f"download is missing: {artifact['path']}")
    dependency_artifact = load(DATA / "axiom-dependencies.json")
    require(
        dependency_artifact["pairs"] == axiom_dependencies
        and dependency_artifact["conditionalEvidence"] == conditional_evidence,
        "axiom dependency artifact disagrees with the manifest",
    )
    require(
        load(DATA / "formalization-frontier.json")["frontier"] == formal_frontier,
        "formalization frontier artifact disagrees with the manifest",
    )
    require(
        load(DATA / "frontier.json")["frontier"] == frontier,
        "pi-Base frontier artifact disagrees with the manifest",
    )
    print(
        "dashboard integrity: "
        f"{size} nodes, {sum(histogram.values()):,} cells, "
        f"{len(formal_frontier):,} formalization and {len(frontier):,} pi-Base frontier pairs, "
        f"{len(implications['pairs']):,} open literal implications, review chunks valid"
    )


if __name__ == "__main__":
    main()

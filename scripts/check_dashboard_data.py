#!/usr/bin/env python3
"""Fail when generated dashboard artifacts disagree with their manifest."""

from __future__ import annotations

import json
import re
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
PUBLIC = ROOT / "dashboard" / "public"
DATA = PUBLIC / "data"


def load(path: Path):
    with path.open(encoding="utf-8") as handle:
        return json.load(handle)


def require(condition: bool, message: str) -> None:
    if not condition:
        raise SystemExit(f"dashboard integrity error: {message}")


def check_review(kind: str, expected: int, source_prefix: str) -> None:
    index = load(DATA / f"review-{kind}.json")
    entries = index["entries"]
    require(len(entries) == expected, f"{kind} review index has {len(entries)} entries, expected {expected}")
    require(len({entry["id"] for entry in entries}) == expected, f"{kind} review index has duplicate IDs")
    require(
        all(entry["sourceUrl"].startswith(source_prefix) for entry in entries),
        f"{kind} review index contains a non-canonical source link",
    )
    if kind == "properties":
        require(
            all("wellDefinedPlaceholders" in entry["leanStatus"] for entry in entries),
            "property review index is missing well-definedness audit data",
        )
    chunk_ids: set[str] = set()
    for chunk_number, relative in enumerate(index["chunks"]):
        path = PUBLIC / relative
        require(path.exists(), f"missing review chunk {relative}")
        payload = load(path)
        require(payload["chunk"] == chunk_number, f"review chunk number mismatch in {relative}")
        require(
            all(entry["sourceUrl"].startswith(source_prefix) for entry in payload["entries"]),
            f"{relative} contains a non-canonical source link",
        )
        chunk_ids.update(entry["id"] for entry in payload["entries"])
    require(chunk_ids == {entry["id"] for entry in entries}, f"{kind} review chunks do not match their index")
    require(all(0 <= entry["chunk"] < len(index["chunks"]) for entry in entries), f"{kind} review entry has an invalid chunk")


def main() -> None:
    manifest = load(DATA / "dashboard.json")
    canonical_repo = "https://github.com/felixpernegger/pibase-lean"
    require(manifest["schemaVersion"] == 4, "unexpected dashboard schema version")
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
    require(
        summary["spaceImplementations"]
        == summary["spaceEntries"] - manifest["trust"]["spaces"].get("missing-declaration", 0),
        "implemented space count disagrees with trust ledger",
    )
    require(summary["propertyImplementations"] <= summary["propertyTotal"], "property coverage exceeds pi-Base total")
    require(summary["theoremImplementations"] <= summary["theoremTotal"], "theorem coverage exceeds pi-Base total")
    require(summary["spaceImplementations"] <= summary["spaceTotal"], "space coverage exceeds pi-Base total")

    check_review("spaces", summary["spaceEntries"], source_prefix)
    check_review("properties", summary["propertyEntries"], source_prefix)
    check_review("theorems", summary["theoremEntries"], source_prefix)

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
    for page in ("blueprint.html", "review.html", "data.html"):
        require((PUBLIC / page).exists(), f"public page is missing: {page}")
    blueprint = (PUBLIC / "blueprint.html").read_text(encoding="utf-8")
    require(canonical_repo in blueprint, "blueprint does not link Felix's repository")
    require("github.com/Deicyde/pibase-lean" not in blueprint, "blueprint contains a fork source link")

    print(
        "dashboard integrity: "
        f"{size} nodes, {sum(histogram.values()):,} cells, "
        f"{len(formal_frontier):,} formalization and {len(frontier):,} pi-Base frontier pairs, "
        f"{len(implications['pairs']):,} open literal implications, review chunks valid"
    )


if __name__ == "__main__":
    main()

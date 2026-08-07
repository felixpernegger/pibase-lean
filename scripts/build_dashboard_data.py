#!/usr/bin/env python3
"""Build the versioned data artifacts consumed by the dashboard application."""

from __future__ import annotations

import json
import os
import re
import shutil
import struct
import subprocess
import sys
from collections import Counter, defaultdict
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SCRIPTS = ROOT / "scripts"
sys.path.insert(0, str(SCRIPTS))

from graph import full_trait_matrix, known_true_edges, transitive_closure  # noqa: E402
from build_project_page import build_blueprint_page  # noqa: E402
from gen_traits import build_traits_data  # noqa: E402

DATA_DIR = ROOT / "data"
PUBLIC_DIR = ROOT / "dashboard" / "public"
OUT_DIR = PUBLIC_DIR / "data"
LEAN_ROOT = Path(
    os.environ.get("PIBASE_LEAN_SOURCE", os.environ.get("FELIX_REPO_PATH", ROOT))
).resolve()
PIBASE_URL = "https://topology.pi-base.org"
REPO_SLUG = "felixpernegger/pibase-lean"
REPO_URL = f"https://github.com/{REPO_SLUG}"


def load_json(path: Path):
    with path.open(encoding="utf-8") as handle:
        return json.load(handle)


def dump_json(path: Path, payload) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as handle:
        json.dump(payload, handle, ensure_ascii=False, separators=(",", ":"))


def git(*args: str) -> str:
    try:
        return subprocess.check_output(
            ["git", "-C", str(LEAN_ROOT), *args],
            text=True,
            stderr=subprocess.DEVNULL,
        ).strip()
    except (OSError, subprocess.CalledProcessError):
        return ""


def is_felix_commit() -> bool:
    """Return whether HEAD is contained in a fetched ref from Felix's repository."""
    for remote in git("remote").splitlines():
        url = git("remote", "get-url", remote).lower().removesuffix(".git").replace(":", "/")
        if not url.endswith(f"github.com/{REPO_SLUG}"):
            continue
        if git(
            "for-each-ref",
            "--format=%(refname)",
            "--contains=HEAD",
            f"refs/remotes/{remote}",
        ):
            return True
    return False


def short_id(uid: str) -> str:
    return f"{uid[0]}{int(uid[1:])}"


def clean_informal(text: str) -> str:
    if not text:
        return ""
    text = text.split("----", 1)[0].strip()
    text = re.sub(r"\{\{[^}]*\}\}", "[reference]", text)
    text = re.sub(r"\{([PST])0*(\d+)(?:\|P0*\d+)?\}", lambda m: f"{m[1]}{int(m[2])}", text)
    return text


def strip_lean_comments_and_strings(source: str) -> str:
    """Remove nested comments and strings while preserving line boundaries."""
    out: list[str] = []
    i = 0
    depth = 0
    in_string = False
    while i < len(source):
        pair = source[i:i + 2]
        char = source[i]
        if depth:
            if pair == "/-":
                depth += 1
                out.extend("  ")
                i += 2
            elif pair == "-/":
                depth -= 1
                out.extend("  ")
                i += 2
            else:
                out.append("\n" if char == "\n" else " ")
                i += 1
            continue
        if in_string:
            if char == "\\" and i + 1 < len(source):
                out.extend("  ")
                i += 2
            elif char == '"':
                in_string = False
                out.append(" ")
                i += 1
            else:
                out.append("\n" if char == "\n" else " ")
                i += 1
            continue
        if pair == "/-":
            depth = 1
            out.extend("  ")
            i += 2
        elif pair == "--":
            end = source.find("\n", i)
            if end == -1:
                out.extend(" " * (len(source) - i))
                break
            out.extend(" " * (end - i))
            out.append("\n")
            i = end + 1
        elif char == '"':
            in_string = True
            out.append(" ")
            i += 1
        else:
            out.append(char)
            i += 1
    return "".join(out)


DECLARATION_HEADER = re.compile(
    r"^\s*(?:(?:private|protected|noncomputable)\s+)*(?:theorem|lemma|def|abbrev|instance)\s+([^\s(:]+)",
    re.MULTILINE,
)


def declaration_placeholders(code: str, name_prefix: str) -> int:
    """Count active placeholders inside declarations with the requested name prefix."""
    headers = list(DECLARATION_HEADER.finditer(code))
    count = 0
    for index, header in enumerate(headers):
        if not header.group(1).startswith(name_prefix):
            continue
        end = headers[index + 1].start() if index + 1 < len(headers) else len(code)
        count += len(re.findall(r"\b(?:sorry|admit)\b", code[header.start():end]))
    return count


def property_field_placeholders(code: str) -> int:
    """Count placeholders in canonical property `well_defined` fields."""
    headers = list(DECLARATION_HEADER.finditer(code))
    count = 0
    for index, header in enumerate(headers):
        if not re.fullmatch(r"P\d+", header.group(1)):
            continue
        end = headers[index + 1].start() if index + 1 < len(headers) else len(code)
        declaration = code[header.start():end]
        field = re.search(r"\bwell_defined\b", declaration)
        if field:
            count += len(re.findall(r"\b(?:sorry|admit)\b", declaration[field.start():]))
    return count


def focused_lean(path: Path) -> str:
    if not path.exists():
        return ""
    boilerplate = re.compile(
        r"^\s*(module\b|public\s+import\b|import\b|@\[expose\]\s*public\s+section\b)"
    )
    lines = [
        line for line in path.read_text(encoding="utf-8", errors="ignore").splitlines()
        if not boilerplate.match(line)
    ]
    return re.sub(r"\n{3,}", "\n\n", "\n".join(lines)).strip()


def load_authors() -> dict[str, str]:
    aliases = {
        "jack.mccarthy.1@stonybrook.edu": "Jack McCarthy",
        "s59fpern@uni-bonn.de": "Felix Pernegger",
    }
    command = [
        "log", "--reverse", "--no-renames", "--diff-filter=A",
        "--format=%x00%an%x09%ae", "--name-only", "--", "PiBaseLean",
    ]
    raw = git(*command)
    authors: dict[str, str] = {}
    current_name = ""
    current_email = ""
    for line in raw.splitlines():
        if line.startswith("\x00"):
            bits = line[1:].split("\t", 1)
            current_name = bits[0]
            current_email = bits[1] if len(bits) > 1 else ""
        elif line.strip() and line not in authors:
            authors[line] = aliases.get(current_email, current_name)
    return authors


def analyze_lean_tree() -> tuple[dict[str, dict], dict[Path, dict]]:
    lean_paths = sorted((LEAN_ROOT / "PiBaseLean").rglob("*.lean"))
    lean_paths.append(LEAN_ROOT / "PiBaseLean.lean")
    module_paths: dict[str, Path] = {}
    analyses: dict[Path, dict] = {}

    for path in lean_paths:
        if not path.exists():
            continue
        rel = path.relative_to(LEAN_ROOT)
        module_paths[str(rel.with_suffix("" )).replace(os.sep, ".")] = path
        source = path.read_text(encoding="utf-8", errors="ignore")
        code = strip_lean_comments_and_strings(source)
        imports = re.findall(
            r"^\s*(?:public\s+)?import\s+([A-Za-z0-9_'.]+)", source, re.MULTILINE
        )
        analyses[path] = {
            "relative": str(rel),
            "placeholders": len(re.findall(r"\b(?:sorry|admit)\b", code)),
            "axioms": len(re.findall(r"^\s*axiom\b", code, re.MULTILINE)),
            "imports": imports,
            "code": code,
            "wellDefinedPlaceholders": (
                declaration_placeholders(code, "WellDefined.")
                + property_field_placeholders(code)
            ),
        }

    dependency_cache: dict[Path, set[Path]] = {}

    def dependencies(path: Path, active: set[Path] | None = None) -> set[Path]:
        if path in dependency_cache:
            return dependency_cache[path]
        active = set(active or ())
        if path in active:
            return set()
        active.add(path)
        found: set[Path] = set()
        for module in analyses.get(path, {}).get("imports", []):
            dep = module_paths.get(module)
            if dep is None:
                continue
            found.add(dep)
            found.update(dependencies(dep, active))
        dependency_cache[path] = found
        return found

    def entity_status(kind: str, number: int, primary_name: str) -> dict:
        folder = LEAN_ROOT / "PiBaseLean" / kind / f"{kind[0]}{number}"
        files = sorted(folder.glob("*.lean")) if folder.exists() else []
        primary = folder / primary_name
        local_placeholders = sum(analyses.get(path, {}).get("placeholders", 0) for path in files)
        local_axioms = sum(analyses.get(path, {}).get("axioms", 0) for path in files)
        well_defined_placeholders = (
            sum(analyses.get(path, {}).get("wellDefinedPlaceholders", 0) for path in files)
            if kind == "Properties"
            else 0
        )
        dependency_files: set[Path] = set()
        for path in files:
            dependency_files.update(dependencies(path))
        dependency_files.difference_update(files)
        dependency_placeholders = sum(
            analyses.get(path, {}).get("placeholders", 0) for path in dependency_files
        )
        dependency_axioms = sum(
            analyses.get(path, {}).get("axioms", 0) for path in dependency_files
        )
        dependency_well_defined_placeholders = sum(
            analyses.get(path, {}).get("wellDefinedPlaceholders", 0) for path in dependency_files
        )
        dependency_non_well_defined_placeholders = max(
            0, dependency_placeholders - dependency_well_defined_placeholders
        )
        declaration = True
        if kind == "Properties":
            declaration = bool(
                primary.exists()
                and re.search(rf"\bdef\s+P{number}\b", analyses[primary]["code"])
            )
        elif kind == "Theorems":
            declaration = bool(
                primary.exists()
                and re.search(rf"\btheorem\s+T{number}\b", analyses[primary]["code"])
            )
        elif kind == "Spaces":
            declaration = bool(
                primary.exists()
                and re.search(rf"\bdef\s+S{number}\b", analyses[primary]["code"])
            )
        dependency_clean = (
            declaration
            and local_placeholders == 0
            and dependency_placeholders == 0
            and local_axioms == 0
            and dependency_axioms == 0
        )
        if not declaration:
            status = "missing-declaration"
        elif local_placeholders or local_axioms:
            status = "local-debt"
        elif dependency_placeholders or dependency_axioms:
            status = "dependency-debt"
        else:
            status = "dependency-clean"
        return {
            "represented": folder.exists(),
            "declarationPresent": declaration,
            "dependencyClean": dependency_clean,
            "status": status,
            "files": len(files),
            "localPlaceholders": local_placeholders,
            "dependencyPlaceholders": dependency_placeholders,
            "localAxioms": local_axioms,
            "dependencyAxioms": dependency_axioms,
            "wellDefinedPlaceholders": well_defined_placeholders,
            "dependencyWellDefinedPlaceholders": dependency_well_defined_placeholders,
            "dependencyNonWellDefinedPlaceholders": dependency_non_well_defined_placeholders,
            "sourcePath": str(primary.relative_to(LEAN_ROOT)) if primary.exists() else "",
        }

    statuses: dict[str, dict] = {}
    for kind, primary in (("Properties", "Defs.lean"), ("Theorems", "Theorem.lean"), ("Spaces", "Defs.lean")):
        prefix = kind[0]
        parent = LEAN_ROOT / "PiBaseLean" / kind
        for folder in parent.glob(f"{prefix}*"):
            match = re.fullmatch(rf"{prefix}(\d+)", folder.name)
            if match:
                number = int(match.group(1))
                statuses[f"{prefix}{number:06d}"] = entity_status(kind, number, primary)
    return statuses, analyses


def formula_text(formula: dict, names: dict[str, str]) -> str:
    if formula["kind"] == "atom":
        uid = formula["property"]
        atom = f"{short_id(uid)} · {names.get(uid, uid)}"
        return atom if formula["value"] else f"not ({atom})"
    separator = " and " if formula["kind"] == "and" else " or "
    return separator.join(formula_text(item, names) for item in formula["subs"])


def direct_theorem_map(data: dict) -> dict[tuple[str, str], list[str]]:
    result: dict[tuple[str, str], list[str]] = defaultdict(list)
    for theorem in data["theorems"]:
        before, after = theorem["when"], theorem["then"]
        if (
            before["kind"] == "atom"
            and after["kind"] == "atom"
            and before["value"]
            and after["value"]
        ):
            result[(before["property"], after["property"])].append(theorem["uid"])
    return result


def rank_frontier(
    nodes: list[str],
    reach: dict[str, set[str]],
    pairs: list[tuple[str, str]],
) -> list[dict]:
    """Rank unresolved edges by the new transitive-closure cells they unlock."""
    ancestors = {uid: {uid} for uid in nodes}
    for source in nodes:
        for target in reach[source]:
            ancestors[target].add(source)

    frontier = []
    for source, target in pairs:
        sources = ancestors[source]
        targets = set(reach[target]) | {target}
        closure_gain = sum(
            1
            for left in sources
            for right in targets
            if left != right and right not in reach[left]
        )
        frontier.append({
            "source": source,
            "target": target,
            "closureGain": closure_gain,
            "sourceAncestors": len(sources) - 1,
            "targetDescendants": len(targets) - 1,
        })
    frontier.sort(
        key=lambda item: (
            -item["closureGain"],
            item["source"],
            item["target"],
        )
    )
    return frontier


def build_graph(
    data: dict,
    axiom_dependencies: dict[tuple[str, str], dict],
    conditional_spaces: dict[str, dict],
) -> dict:
    nodes = [item["uid"] for item in data["properties"]]
    index = {uid: i for i, uid in enumerate(nodes)}
    direct_edges = known_true_edges(data)
    reach = transitive_closure(direct_edges, nodes)
    traits = full_trait_matrix(data)
    spaces = [item["uid"] for item in data["spaces"]]
    unknown_conditional_spaces = set(conditional_spaces) - set(spaces)
    if unknown_conditional_spaces:
        raise SystemExit(
            "unknown conditional spaces: " + ", ".join(sorted(unknown_conditional_spaces))
        )
    for space, condition in conditional_spaces.items():
        if not condition.get("assumptions"):
            raise SystemExit(f"conditional space has no named assumption: {space}")
    unconditional_spaces = [space for space in spaces if space not in conditional_spaces]
    theorem_map = direct_theorem_map(data)
    outcomes = bytearray()
    witnesses: list[int] = []
    witness_counts: Counter[str] = Counter()
    counts: Counter[str] = Counter()
    unclassified_pairs: list[tuple[str, str]] = []
    conditional_evidence: dict[tuple[str, str], list[dict]] = {}

    for (source, target), dependency in axiom_dependencies.items():
        if source not in index or target not in index or source == target:
            raise SystemExit(f"invalid axiom-dependent implication: {source} -> {target}")
        if target in reach[source]:
            raise SystemExit(f"axiom-dependent implication is already unconditionally true: {source} -> {target}")
        if not dependency.get("axioms"):
            raise SystemExit(f"axiom-dependent implication has no named axiom: {source} -> {target}")
        if not dependency.get("trueWhen") or not dependency.get("falseWhen"):
            raise SystemExit(
                f"axiom-dependent implication lacks truth conditions: {source} -> {target}"
            )

    for source in nodes:
        for target in nodes:
            witness_index = 0
            if source == target:
                state = 0
                counts["diagonal"] += 1
            elif target in direct_edges.get(source, ()):
                state = 1
                counts["explicitTrue"] += 1
            elif target in reach[source]:
                state = 2
                counts["derivedTrue"] += 1
            else:
                witness = next(
                    (
                        space for space in unconditional_spaces
                        if traits[space].get(source) is True
                        and traits[space].get(target) is False
                    ),
                    None,
                )
                if witness:
                    if (source, target) in axiom_dependencies:
                        raise SystemExit(
                            "axiom-dependent implication has an unconditional counterexample: "
                            f"{source} -> {target} via {witness}"
                        )
                    state = 3
                    witness_index = spaces.index(witness) + 1
                    witness_counts[witness] += 1
                    counts["false"] += 1
                elif (source, target) in axiom_dependencies:
                    state = 4
                    counts["axiomDependent"] += 1
                else:
                    state = 5
                    counts["unclassified"] += 1
                    unclassified_pairs.append((source, target))

                if witness is None:
                    conditional_witnesses = [
                        {
                            "space": space,
                            "assumptions": conditional_spaces[space].get("assumptions", []),
                            "condition": conditional_spaces[space].get("condition", ""),
                            "summary": conditional_spaces[space].get("summary", ""),
                            "referenceUrl": conditional_spaces[space].get(
                                "referenceUrl", f"{PIBASE_URL}/spaces/{space}"
                            ),
                        }
                        for space in conditional_spaces
                        if traits[space].get(source) is True
                        and traits[space].get(target) is False
                    ]
                    if conditional_witnesses:
                        conditional_evidence[(source, target)] = conditional_witnesses
            outcomes.append(state)
            witnesses.append(witness_index)

    frontier = rank_frontier(nodes, reach, unclassified_pairs)
    for item in frontier:
        pair = (item["source"], item["target"])
        item["conditionalEvidence"] = bool(conditional_evidence.get(pair))
        item["axioms"] = sorted({
            axiom
            for witness in conditional_evidence.get(pair, [])
            for axiom in witness["assumptions"]
        })

    direct = [
        {
            "source": source,
            "target": target,
            "theorems": theorem_map.get((source, target), []),
        }
        for source in nodes
        for target in sorted(direct_edges.get(source, ()))
        if target in index
    ]
    return {
        "nodes": nodes,
        "outcomes": outcomes,
        "witnesses": witnesses,
        "spaces": spaces,
        "counts": dict(counts),
        "direct": direct,
        "frontier": frontier,
        "witnessCounts": dict(witness_counts),
        "axiomDependencies": sorted(
            axiom_dependencies.values(),
            key=lambda item: (item["source"], item["target"]),
        ),
        "conditionalEvidence": [
            {"source": source, "target": target, "witnesses": evidence}
            for (source, target), evidence in sorted(conditional_evidence.items())
        ],
        "reach": reach,
    }


def build_formalized_graph(
    data: dict,
    statuses: dict[str, dict],
    pibase_graph: dict,
) -> dict:
    """Project locally placeholder-free Lean pairwise theorem declarations onto the graph."""
    nodes = [item["uid"] for item in data["properties"]]
    node_set = set(nodes)
    theorem_map = direct_theorem_map(data)
    direct_edges: dict[str, set[str]] = defaultdict(set)
    formal_theorems: dict[tuple[str, str], list[str]] = {}

    for (source, target), theorem_ids in theorem_map.items():
        implemented = []
        for uid in theorem_ids:
            status = statuses.get(uid, {})
            if (
                status.get("declarationPresent", False)
                and status.get("localPlaceholders", 0) == 0
                and status.get("localAxioms", 0) == 0
            ):
                implemented.append(uid)
        if implemented and source in node_set and target in node_set:
            direct_edges[source].add(target)
            formal_theorems[(source, target)] = implemented

    reach = transitive_closure(direct_edges, nodes)
    outcomes = bytearray()
    counts: Counter[str] = Counter()
    for source in nodes:
        for target in nodes:
            if source == target:
                state = 0
                counts["diagonal"] += 1
            elif target in direct_edges.get(source, ()):
                state = 1
                counts["formalizedDirect"] += 1
            elif target in reach[source]:
                state = 2
                counts["formalizedDerived"] += 1
            else:
                state = 5
                counts["notFormalized"] += 1
            outcomes.append(state)

    direct = [
        {
            "source": source,
            "target": target,
            "theorems": formal_theorems[(source, target)],
        }
        for source in nodes
        for target in sorted(direct_edges.get(source, ()))
    ]
    pibase_direct = {
        (edge["source"], edge["target"])
        for edge in pibase_graph["direct"]
    }
    candidates = [
        (source, target)
        for source in nodes
        for target in pibase_graph["reach"][source]
        if source != target and target not in reach[source]
    ]
    frontier = rank_frontier(nodes, reach, candidates)
    for item in frontier:
        pair = (item["source"], item["target"])
        item["pibaseStatus"] = "direct" if pair in pibase_direct else "derived"

    return {
        "outcomes": outcomes,
        "counts": dict(counts),
        "direct": direct,
        "frontier": frontier,
    }


def recent_activity() -> tuple[list[dict], dict]:
    rows = git(
        "log", "-8", "--date=short", "--pretty=format:%H%x1f%h%x1f%cs%x1f%s",
        "--", "PiBaseLean",
    )
    commits = []
    for row in rows.splitlines():
        bits = row.split("\x1f", 3)
        if len(bits) == 4:
            commits.append({"sha": bits[0], "short": bits[1], "date": bits[2], "subject": bits[3]})
    changes = Counter()
    for row in git("diff", "--name-status", "HEAD^", "HEAD", "--", "PiBaseLean").splitlines():
        if not row:
            continue
        status, path = (row.split("\t", 1) + [""])[:2]
        changes[{"A": "added", "M": "modified", "D": "deleted"}.get(status[0], "other")] += 1
        if "/Properties/" in path:
            changes["propertyFiles"] += 1
        elif "/Theorems/" in path:
            changes["theoremFiles"] += 1
        elif "/Spaces/" in path:
            changes["spaceFiles"] += 1
    return commits, dict(changes)


def source_url(commit: str, path: str) -> str:
    return f"{REPO_URL}/blob/{commit}/{path}"


def build_review_payloads(
    data: dict,
    statuses: dict[str, dict],
    commit: str,
    generated_at: str,
    traits: dict,
) -> None:
    authors = load_authors()
    properties = {item["uid"]: item for item in data["properties"]}
    spaces = {item["uid"]: item for item in data["spaces"]}
    theorems = {item["uid"]: item for item in data["theorems"]}
    names = {uid: item["name"] for uid, item in properties.items()}

    payloads: dict[str, list[dict]] = {"spaces": [], "properties": [], "theorems": []}

    for uid in sorted((key for key in statuses if key.startswith("S")), key=lambda key: int(key[1:])):
        number = int(uid[1:])
        rel = f"PiBaseLean/Spaces/S{number}/Defs.lean"
        extra = LEAN_ROOT / "PiBaseLean" / "Spaces" / f"S{number}" / "Lemmas.lean"
        item = spaces.get(uid, {})
        trait_rows = traits.get(uid, {}).get("traits", [])
        payloads["spaces"].append({
            "id": uid,
            "shortId": short_id(uid),
            "name": item.get("name", short_id(uid)),
            "aliases": item.get("aliases", []),
            "description": clean_informal(item.get("description", "")),
            "author": authors.get(rel, ""),
            "sourcePath": rel,
            "sourceUrl": source_url(commit, rel),
            "referenceUrl": f"{PIBASE_URL}/spaces/{uid}",
            "code": focused_lean(LEAN_ROOT / rel),
            "extraCode": focused_lean(extra),
            "leanStatus": statuses[uid],
            "traits": trait_rows,
            "traitSummary": dict(Counter(row.get("status", "unknown") for row in trait_rows)),
        })

    for uid in sorted((key for key in statuses if key.startswith("P")), key=lambda key: int(key[1:])):
        number = int(uid[1:])
        rel = f"PiBaseLean/Properties/P{number}/Defs.lean"
        extra = LEAN_ROOT / "PiBaseLean" / "Properties" / f"P{number}" / "Lemmas.lean"
        item = properties.get(uid, {})
        payloads["properties"].append({
            "id": uid,
            "shortId": short_id(uid),
            "name": item.get("name", short_id(uid)),
            "aliases": item.get("aliases", []),
            "description": clean_informal(item.get("description", "")),
            "author": authors.get(rel, ""),
            "sourcePath": rel,
            "sourceUrl": source_url(commit, rel),
            "referenceUrl": f"{PIBASE_URL}/properties/{uid}",
            "code": focused_lean(LEAN_ROOT / rel),
            "extraCode": focused_lean(extra),
            "leanStatus": statuses[uid],
        })

    for uid in sorted((key for key in statuses if key.startswith("T")), key=lambda key: int(key[1:])):
        number = int(uid[1:])
        rel = f"PiBaseLean/Theorems/T{number}/Theorem.lean"
        extra = LEAN_ROOT / "PiBaseLean" / "Theorems" / f"T{number}" / "Lemmas.lean"
        item = theorems.get(uid, {})
        statement = "Statement unavailable"
        if item:
            statement = f"{formula_text(item['when'], names)}  ⇒  {formula_text(item['then'], names)}"
        payloads["theorems"].append({
            "id": uid,
            "shortId": short_id(uid),
            "name": statement,
            "aliases": [],
            "description": clean_informal(item.get("description", "")),
            "author": authors.get(rel, ""),
            "sourcePath": rel,
            "sourceUrl": source_url(commit, rel),
            "referenceUrl": f"{PIBASE_URL}/theorems/{uid}",
            "code": focused_lean(LEAN_ROOT / rel),
            "extraCode": focused_lean(extra),
            "leanStatus": statuses[uid],
        })

    chunk_size = 24
    for kind, entries in payloads.items():
        chunks = []
        index_entries = []
        for chunk_index, start in enumerate(range(0, len(entries), chunk_size)):
            chunk_entries = entries[start:start + chunk_size]
            chunk_path = f"data/review-{kind}-{chunk_index:03d}.json"
            chunks.append(chunk_path)
            dump_json(OUT_DIR / f"review-{kind}-{chunk_index:03d}.json", {
                "schemaVersion": 1,
                "kind": kind,
                "chunk": chunk_index,
                "sourceCommit": commit,
                "entries": chunk_entries,
            })
            for entry in chunk_entries:
                index_entries.append({
                    "id": entry["id"],
                    "shortId": entry["shortId"],
                    "name": entry["name"],
                    "aliases": entry["aliases"],
                    "author": entry["author"],
                    "sourceUrl": entry["sourceUrl"],
                    "referenceUrl": entry["referenceUrl"],
                    "leanStatus": entry["leanStatus"],
                    "chunk": chunk_index,
                })
        dump_json(OUT_DIR / f"review-{kind}.json", {
            "schemaVersion": 1,
            "kind": kind,
            "sourceCommit": commit,
            "generatedAt": generated_at,
            "chunkSize": chunk_size,
            "chunks": chunks,
            "entries": index_entries,
        })


def validate_implications(payload) -> None:
    """Check the internal alignment of the pibase-data engine payload.

    The payload is produced by felixpernegger/pibase-data's build_site.py and
    replayed verbatim by dashboard/src/engine.ts, so every parallel-array
    invariant the browser engine relies on is enforced here.
    """
    def require(condition: bool, message: str) -> None:
        if not condition:
            raise SystemExit(f"implications payload error: {message}")

    require(payload.get("repo") == "felixpernegger/pibase-data", "unexpected source repository")
    prop_ids = payload["prop_ids"]
    prop_count = len(prop_ids)
    require(prop_count > 0, "empty property list")
    require(len(payload["prop_names"]) == prop_count, "prop_names is not aligned with prop_ids")
    require(len(set(prop_ids)) == prop_count, "duplicate property ids")
    require(len(payload["clauses"]) == len(payload["clause_ids"]), "clause_ids is not aligned with clauses")
    require(len(payload["models"]) == len(payload["model_meta"]), "model_meta is not aligned with models")
    for clause in payload["clauses"]:
        require(
            bool(clause) and all(isinstance(lit, int) and 0 <= lit < 2 * prop_count for lit in clause),
            "clause literal out of range",
        )
    for model in payload["models"]:
        require(len(model) == prop_count and set(model) <= {"0", "1", "?"}, "malformed model string")
    known = set(prop_ids)
    def atoms(value):
        return value if isinstance(value, list) else [value]
    for pair in payload["pairs"]:
        for atom in [*atoms(pair["if"]), pair["then"]]:
            require(atom["uid"] in known, f"pair references unknown property {atom['uid']}")
    for assertion in payload["assertions"]:
        for atom in [*atoms(assertion["if"]), assertion["then"]]:
            require(atom["uid"] in known, f"assertion references unknown property {atom['uid']}")
    require(payload["counts"]["unknown"] == len(payload["pairs"]), "counts.unknown disagrees with pairs")
    accepted = len(payload["assertions"])
    for meta in payload["model_meta"]:
        if meta["kind"] == "assertion":
            require(0 <= meta["index"] < accepted, "model_meta assertion index out of range")


def main() -> None:
    if not (LEAN_ROOT / "PiBaseLean").is_dir():
        raise SystemExit(f"Lean source tree not found at {LEAN_ROOT}")
    commit = git("rev-parse", "HEAD")
    if not commit:
        raise SystemExit(f"Lean source at {LEAN_ROOT} is not a Git checkout")
    if git("status", "--porcelain", "--", "PiBaseLean", "PiBaseLean.lean"):
        raise SystemExit(f"Lean source at {LEAN_ROOT} has uncommitted changes")
    if not is_felix_commit():
        raise SystemExit(
            f"Lean source commit {commit[:8]} is not contained in a fetched {REPO_SLUG} ref"
        )
    if OUT_DIR.exists():
        shutil.rmtree(OUT_DIR)
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    data = load_json(DATA_DIR / "pibase.json")
    coverage = load_json(DATA_DIR / "coverage.json")
    registry = load_json(DATA_DIR / "registry.json")
    foundations = load_json(DATA_DIR / "independence.json")
    implications = load_json(DATA_DIR / "implications.json")
    validate_implications(implications)
    base_theory = foundations.get("baseTheory", "ZFC")
    axiom_dependency_records = [
        {
            "source": item["hypothesis"],
            "target": item["conclusion"],
            "baseTheory": item.get("baseTheory", base_theory),
            "axioms": item.get("axioms", []),
            "trueWhen": item.get("trueWhen", ""),
            "falseWhen": item.get("falseWhen", ""),
            "summary": item.get("summary", ""),
            "theorems": item.get("theorems", []),
            "referenceUrl": item.get("referenceUrl", ""),
        }
        for item in foundations.get("pairs", [])
        if item.get("hypothesis") and item.get("conclusion")
    ]
    axiom_dependencies = {
        (item["source"], item["target"]): item
        for item in axiom_dependency_records
    }
    if len(axiom_dependencies) != len(axiom_dependency_records):
        raise SystemExit("duplicate axiom-dependent implication records")
    conditional_spaces = {
        item["space"]: item
        for item in foundations.get("conditionalSpaces", [])
        if item.get("space")
    }
    if len(conditional_spaces) != len(foundations.get("conditionalSpaces", [])):
        raise SystemExit("duplicate or incomplete conditional-space records")

    generated_at = datetime.now(timezone.utc).replace(microsecond=0).isoformat()
    commit_short = commit[:8]
    branch = git("branch", "--show-current") or "master"
    source_date = git("log", "-1", "--format=%cI")[:10]
    statuses, analyses = analyze_lean_tree()
    graph = build_graph(data, axiom_dependencies, conditional_spaces)
    formalized_graph = build_formalized_graph(data, statuses, graph)
    names = {item["uid"]: item["name"] for item in data["properties"]}
    recent, delta = recent_activity()

    # Derived worklists are generated here rather than committed: the open
    # questions come straight from the graph classification, and the trait
    # tables replay pi-base deduction against the current Lean tree.
    if len(graph["frontier"]) != graph["counts"].get("unclassified", 0):
        raise SystemExit("frontier does not cover every unclassified pair")
    questions = {
        "node_count": len(graph["nodes"]),
        "open_count": len(graph["frontier"]),
        "questions": [
            {
                "hypothesis": item["source"],
                "hypothesis_name": names[item["source"]],
                "conclusion": item["target"],
                "conclusion_name": names[item["target"]],
                "lean": f"Implies {item['source']} {item['target']}",
            }
            for item in graph["frontier"]
        ],
    }
    traits = build_traits_data(data, LEAN_ROOT)

    properties = []
    for item in data["properties"]:
        uid = item["uid"]
        properties.append({
            "id": uid,
            "shortId": short_id(uid),
            "name": item["name"],
            "aliases": item.get("aliases", []),
            "description": clean_informal(item.get("description", "")),
            "lean": statuses.get(uid),
            "registry": registry.get("properties", {}).get(uid),
            "referenceUrl": f"{PIBASE_URL}/properties/{uid}",
        })

    spaces = [
        {
            "id": item["uid"],
            "shortId": short_id(item["uid"]),
            "name": item["name"],
            "referenceUrl": f"{PIBASE_URL}/spaces/{item['uid']}",
            "lean": statuses.get(item["uid"]),
            "assumptions": conditional_spaces.get(item["uid"], {}).get("assumptions", []),
        }
        for item in data["spaces"]
    ]

    theorem_statuses = [value for key, value in statuses.items() if key.startswith("T")]
    property_statuses = [value for key, value in statuses.items() if key.startswith("P")]
    space_statuses = [value for key, value in statuses.items() if key.startswith("S")]
    theorem_implementations = sum(
        item["declarationPresent"]
        and item["localPlaceholders"] == 0
        and item["localAxioms"] == 0
        for item in theorem_statuses
    )
    trust = {
        "properties": dict(Counter(item["status"] for item in property_statuses)),
        "theorems": dict(Counter(item["status"] for item in theorem_statuses)),
        "spaces": dict(Counter(item["status"] for item in space_statuses)),
        "projectPlaceholders": sum(item["placeholders"] for item in analyses.values()),
        "projectAxioms": sum(item["axioms"] for item in analyses.values()),
    }

    counts = graph["counts"]
    total_pairs = len(graph["nodes"]) * (len(graph["nodes"]) - 1)
    resolved = (
        counts.get("explicitTrue", 0)
        + counts.get("derivedTrue", 0)
        + counts.get("false", 0)
        + counts.get("axiomDependent", 0)
    )
    dashboard = {
        "schemaVersion": 4,
        "project": {
            "id": "pibase-lean",
            "name": "pibase-lean",
            "domain": "Topological property implications",
            "repoUrl": REPO_URL,
            "repositoryLabel": "felixpernegger/pibase-lean",
            "referenceUrl": PIBASE_URL,
        },
        "source": {
            "commit": commit,
            "commitShort": commit_short,
            "branch": branch,
            "sourceDate": source_date,
            "generatedAt": generated_at,
            "dataSha": data.get("version", {}).get("sha", coverage.get("pin_sha", "")),
        },
        "summary": {
            "propertyEntries": len(property_statuses),
            "propertyImplementations": sum(item["declarationPresent"] for item in property_statuses),
            "propertyTotal": len(data["properties"]),
            "mappedProperties": len(registry.get("properties", {})),
            "theoremEntries": len(theorem_statuses),
            "theoremTotal": len(data["theorems"]),
            "theoremImplementations": theorem_implementations,
            "dependencyCleanTheorems": sum(item["dependencyClean"] for item in theorem_statuses),
            "spaceEntries": len(space_statuses),
            "spaceImplementations": sum(item["declarationPresent"] for item in space_statuses),
            "spaceTotal": len(data["spaces"]),
            "resolvedPairs": resolved,
            "totalPairs": total_pairs,
            "unclassifiedPairs": counts.get("unclassified", 0),
        },
        "trust": trust,
        "graph": {
            "size": len(graph["nodes"]),
            "counts": counts,
            "outcomesPath": "data/outcomes.bin",
            "witnessesPath": "data/witnesses.bin",
            "statusCodes": {
                "0": "diagonal",
                "1": "explicit-true",
                "2": "derived-true",
                "3": "false",
                "4": "axiom-dependent",
                "5": "unclassified",
            },
            "direct": graph["direct"],
            "witnessCounts": graph["witnessCounts"],
            "axiomDependencies": graph["axiomDependencies"],
            "conditionalEvidence": graph["conditionalEvidence"],
            "formalized": {
                "counts": formalized_graph["counts"],
                "outcomesPath": "data/formalized-outcomes.bin",
                "direct": formalized_graph["direct"],
                "frontier": formalized_graph["frontier"],
            },
        },
        "properties": properties,
        "spaces": spaces,
        "frontier": graph["frontier"],
        "recentActivity": recent,
        "latestDelta": delta,
        "downloads": [
            {"label": "Dashboard manifest", "path": "data/dashboard.json", "format": "JSON"},
            {"label": "Outcome matrix", "path": "data/outcomes.bin", "format": "Uint8"},
            {"label": "Formalized outcome matrix", "path": "data/formalized-outcomes.bin", "format": "Uint8"},
            {"label": "Witness matrix", "path": "data/witnesses.bin", "format": "Uint16 LE"},
            {"label": "Set-theoretic independence", "path": "data/axiom-dependencies.json", "format": "JSON"},
            {"label": "Formalization frontier", "path": "data/formalization-frontier.json", "format": "JSON"},
            {"label": "π-Base frontier", "path": "data/frontier.json", "format": "JSON"},
            {"label": "Review: spaces", "path": "data/review-spaces.json", "format": "JSON"},
            {"label": "Review: properties", "path": "data/review-properties.json", "format": "JSON"},
            {"label": "Review: theorems", "path": "data/review-theorems.json", "format": "JSON"},
            {"label": "Implications engine payload", "path": "data/implications.json", "format": "JSON"},
            {"label": "Open questions worklist", "path": "data/questions.json", "format": "JSON"},
            {"label": "Space trait tables", "path": "data/traits.json", "format": "JSON"},
        ],
    }

    dump_json(OUT_DIR / "dashboard.json", dashboard)
    dump_json(OUT_DIR / "implications.json", implications)
    dump_json(OUT_DIR / "questions.json", questions)
    dump_json(OUT_DIR / "traits.json", traits)
    dump_json(OUT_DIR / "frontier.json", {
        "schemaVersion": 1,
        "sourceCommit": commit,
        "properties": {uid: names[uid] for uid in graph["nodes"]},
        "frontier": graph["frontier"],
    })
    dump_json(OUT_DIR / "formalization-frontier.json", {
        "schemaVersion": 1,
        "sourceCommit": commit,
        "properties": {uid: names[uid] for uid in graph["nodes"]},
        "frontier": formalized_graph["frontier"],
    })
    dump_json(OUT_DIR / "axiom-dependencies.json", {
        "schemaVersion": 1,
        "sourceCommit": commit,
        "baseTheory": base_theory,
        "pairs": graph["axiomDependencies"],
        "conditionalEvidence": graph["conditionalEvidence"],
    })
    (OUT_DIR / "outcomes.bin").write_bytes(graph["outcomes"])
    (OUT_DIR / "formalized-outcomes.bin").write_bytes(formalized_graph["outcomes"])
    (OUT_DIR / "witnesses.bin").write_bytes(
        b"".join(struct.pack("<H", value) for value in graph["witnesses"])
    )
    build_review_payloads(data, statuses, commit, generated_at, traits)

    legacy_summary = {
        "total": total_pairs,
        "true": counts.get("explicitTrue", 0) + counts.get("derivedTrue", 0),
        "explicitly_true": counts.get("explicitTrue", 0),
        "implicitly_true": counts.get("derivedTrue", 0),
        "false": counts.get("false", 0),
        "independent": counts.get("axiomDependent", 0),
        "axiom_dependent": counts.get("axiomDependent", 0),
        "open": counts.get("unclassified", 0),
        "witness_count": graph["witnessCounts"],
    }
    (PUBLIC_DIR / "blueprint.html").write_text(
        build_blueprint_page(data, coverage, questions, legacy_summary),
        encoding="utf-8",
    )

    print(
        "dashboard data: "
        f"{len(properties)} properties, {len(formalized_graph['frontier'])} formalization candidates, "
        f"{len(graph['frontier'])} unclassified pairs, "
        f"{theorem_implementations} implemented theorem rows from {commit_short}"
    )


if __name__ == "__main__":
    main()

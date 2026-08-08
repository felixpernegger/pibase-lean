#!/usr/bin/env python3
"""
graph.py — the property-implication graph (the Equational-Theories-Project object).

Nodes are topological *properties*. We want, for every ordered pair (P, Q), the
truth of the implication

        P  ⟹  Q          "every space with property P also has property Q".

This is the topology analog of ETP's implication graph over equational laws. Each
cell is one of:

  * TRUE   — there is a proof. We seed the known-true edges from pi-base's
             single-property theorems and take their transitive closure.
  * FALSE  — there is a *separating space*: a space S with S ⊨ P and S ⊭ Q. The
             unconditional spaces are the refutation witnesses (ETP's finite
             magmas). We scan the full trait closure of pi-base's space library.
  * AXIOM-DEPENDENT — a certificate records that the truth value changes with a
             named additional axiom such as CH.
  * OPEN   — no unconditional proof, unconditional witness, or dependency
             certificate is known. These are the auto-generated new questions.

The point of the project is to *complete this graph* in Lean: formalize the
properties (nodes) and enough spaces (witnesses) that every FALSE cell has a
kernel-checked separating space, prove a generating set of TRUE edges, and shrink
OPEN toward zero — surfacing, along the way, implications pi-base never recorded.

Usage:
  python3 scripts/graph.py                 # full 244-node grid summary
  python3 scripts/graph.py --mapped        # restrict to properties mapped to Mathlib
  python3 scripts/graph.py --open 25       # sample OPEN pairs (the new questions)
  python3 scripts/graph.py --witnesses     # which spaces refute the most edges
"""
import json
import os
import sys
from collections import defaultdict

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(ROOT, "scripts"))
from closure import atoms, close_space  # noqa: E402

DATA = os.path.join(ROOT, "data", "pibase.json")
REGISTRY = os.path.join(ROOT, "data", "registry.json")
FOUNDATIONS = os.path.join(ROOT, "data", "independence.json")


def full_trait_matrix(data):
    """Every space's complete (asserted + derived) property assignment."""
    theorems = data["theorems"]
    by_prop = defaultdict(list)
    for t in theorems:
        for p in {a[0] for a in atoms(t["when"])} | {a[0] for a in atoms(t["then"])}:
            by_prop[p].append(t)
    asserted = defaultdict(dict)
    for tr in data["traits"]:
        asserted[tr["space"]][tr["property"]] = tr["value"]
    matrix = {}
    for s in (sp["uid"] for sp in data["spaces"]):
        known, _ = close_space(asserted.get(s, {}), by_prop, theorems)
        matrix[s] = known
    return matrix


def known_true_edges(data):
    """Directed edges P->Q for each pi-base theorem that is exactly
    (single positive atom) -> (single positive atom): a bare P ⟹ Q implication."""
    edges = defaultdict(set)
    for t in data["theorems"]:
        w, c = t["when"], t["then"]
        if (w["kind"] == "atom" and c["kind"] == "atom" and w["value"] and c["value"]):
            edges[w["property"]].add(c["property"])
    return edges


def transitive_closure(edges, nodes):
    """Reflexive-transitive closure of the implication edges (DFS per node)."""
    reach = {}
    for n in nodes:
        seen = set()
        stack = [n]
        while stack:
            x = stack.pop()
            for y in edges.get(x, ()):
                if y not in seen:
                    seen.add(y)
                    stack.append(y)
        reach[n] = seen
    return reach


def main():
    data = json.load(open(DATA))
    foundations = json.load(open(FOUNDATIONS))
    pname = {p["uid"]: p["name"] for p in data["properties"]}
    sname = {s["uid"]: s["name"] for s in data["spaces"]}
    axiom_dependent = {
        (item["hypothesis"], item["conclusion"])
        for item in foundations.get("pairs", [])
        if item.get("hypothesis") and item.get("conclusion")
    }
    conditional_spaces = {
        item["space"]
        for item in foundations.get("conditionalSpaces", [])
        if item.get("space")
    }

    nodes = [p["uid"] for p in data["properties"]]
    if "--mapped" in sys.argv:
        reg = json.load(open(REGISTRY))["properties"]
        nodes = [n for n in nodes if n in reg]

    matrix = full_trait_matrix(data)
    reach = transitive_closure(known_true_edges(data), nodes)

    nodeset = set(nodes)
    true_pairs = refuted_pairs = dependent_pairs = open_pairs = 0
    open_list = []
    witness_count = defaultdict(int)   # space -> #edges it refutes (within nodeset)

    for p in nodes:
        for q in nodes:
            if p == q:
                continue
            if q in reach[p]:
                true_pairs += 1
                continue
            # look for a separating space: S ⊨ P and S ⊭ Q
            witness = None
            for s, known in matrix.items():
                if s in conditional_spaces:
                    continue
                if known.get(p) is True and known.get(q) is False:
                    witness = s
                    break
            if witness is not None:
                refuted_pairs += 1
                witness_count[witness] += 1
            elif (p, q) in axiom_dependent:
                dependent_pairs += 1
            else:
                open_pairs += 1
                open_list.append((p, q))

    total = len(nodes) * (len(nodes) - 1)
    print(f"implication grid over {len(nodes)} properties = {total} ordered pairs")
    print(f"  TRUE  (proof / transitive closure):     {true_pairs:6d}  ({100*true_pairs//total}%)")
    print(f"  FALSE (unconditional separating space):  {refuted_pairs:6d}  ({100*refuted_pairs//total}%)")
    print(f"  AXIOM-DEPENDENT (certified):              {dependent_pairs:6d}  ({100*dependent_pairs//total}%)")
    print(f"  OPEN  (not yet classified):              {open_pairs:6d}  ({100*open_pairs//total}%)")
    print(f"  -> {len(witness_count)} distinct spaces witness all the refutations")

    if "--witnesses" in sys.argv:
        print("\nmost-separating spaces (edges refuted, within this node set):")
        for s, c in sorted(witness_count.items(), key=lambda kv: -kv[1])[:15]:
            print(f"  {c:5d}  {s}  «{sname[s]}»")

    if "--open" in sys.argv:
        i = sys.argv.index("--open")
        n = int(sys.argv[i + 1]) if len(sys.argv) > i + 1 else 25
        print(f"\nsample OPEN implications (candidate new theorems — prove or refute):")
        for p, q in open_list[:n]:
            print(f"  {p} «{pname[p]}»  ⟹?  {q} «{pname[q]}»")

    if "--emit-questions" in sys.argv:
        out = os.path.join(ROOT, "data", "questions.json")
        qs = [{"hypothesis": p, "hypothesis_name": pname[p],
               "conclusion": q, "conclusion_name": pname[q],
               "lean": f"Implies {p} {q}"} for p, q in open_list]
        json.dump({"node_count": len(nodes), "open_count": len(qs), "questions": qs},
                  open(out, "w"), indent=1, ensure_ascii=False)
        print(f"\nwrote {len(qs)} open questions to data/questions.json")


if __name__ == "__main__":
    main()

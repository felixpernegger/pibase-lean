#!/usr/bin/env python3
"""
closure.py — pi-base's deduction, in Python, over the pinned data.

A faithful re-implementation of the pi-base prover's core: three-valued
forward chaining with contrapositive propagation. For each space it starts from
the asserted traits and repeatedly fires every theorem `(⋀ atoms) → atom`:

    * if the antecedent is fully True, force the consequent      (modus ponens)
    * if the consequent is False,     force the negated antecedent (modus tollens)

until a fixpoint. This is the same closure the live site computes; we use it to:

  1. **Find the generating set.** A trait is *asserted* (a human put it in the
     database) or *derived* (the closure produced it). Only asserted traits need
     a Lean proof — the derived ones follow, in Lean, from the theorem lemmas.
     This is the pi-base analog of ETP's transitive reduction.

  2. **Detect inconsistencies.** If the closure ever forces a property both True
     and False for one space, the database (or our reading of it) is unsound.

  3. **Enumerate open questions.** A `(space, property)` cell still Unknown after
     closure is exactly a pi-base `/questions` item — a candidate to prove or
     refute in Lean, and possibly a result to send back upstream.

Usage:  python3 scripts/closure.py            # summary
        python3 scripts/closure.py --questions [N]   # sample N open questions
"""
import json
import os
import sys
from collections import defaultdict

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DATA = os.path.join(ROOT, "data", "pibase.json")


def atoms(f):
    if f["kind"] == "atom":
        yield (f["property"], f["value"])
    else:
        for s in f["subs"]:
            yield from atoms(s)


def eval3(f, known):
    """Three-valued (Kleene) evaluation of a formula against a partial
    assignment `known: prop -> bool`. Returns True / False / None."""
    if f["kind"] == "atom":
        v = known.get(f["property"])
        return None if v is None else (v == f["value"])
    vals = [eval3(s, known) for s in f["subs"]]
    if f["kind"] == "and":
        if False in vals:
            return False
        return True if all(v is True for v in vals) else None
    else:  # or
        if True in vals:
            return True
        return False if all(v is False for v in vals) else None


def negate(f):
    if f["kind"] == "atom":
        return {"kind": "atom", "property": f["property"], "value": not f["value"]}
    kind = "or" if f["kind"] == "and" else "and"
    return {"kind": kind, "subs": [negate(s) for s in f["subs"]]}


def force(f, known, changed):
    """Assert that formula `f` holds; propagate into `known`.
    Returns 'contradiction' or None. Only fully determined forcings are made
    (unit propagation for disjunctions is intentionally omitted — the current
    pi-base data has no disjunctions, so this matches it exactly)."""
    if f["kind"] == "atom":
        p, v = f["property"], f["value"]
        if p in known:
            if known[p] != v:
                return "contradiction"
        else:
            known[p] = v
            changed.append(p)
        return None
    if f["kind"] == "and":
        for s in f["subs"]:
            if force(s, known, changed) == "contradiction":
                return "contradiction"
        return None
    # or: only force if exactly one disjunct can still be true
    live = [s for s in f["subs"] if eval3(s, known) is not False]
    if not live:
        return "contradiction"
    if len(live) == 1:
        return force(live[0], known, changed)
    return None


def close_space(seed, theorems_by_prop, theorems):
    """Forward-chain from asserted traits `seed` for one space.
    Returns (known, contradiction_theorem_uid_or_None)."""
    known = dict(seed)
    queue = list(known.keys())
    while queue:
        p = queue.pop()
        for t in theorems_by_prop.get(p, ()):
            a = eval3(t["when"], known)
            c = eval3(t["then"], known)
            if a is True and c is False:
                return known, t["uid"]
            changed = []
            if a is True:
                if force(t["then"], known, changed) == "contradiction":
                    return known, t["uid"]
            if c is False:
                if force(negate(t["when"]), known, changed) == "contradiction":
                    return known, t["uid"]
            queue.extend(changed)
    return known, None


def main():
    data = json.load(open(DATA))
    theorems = data["theorems"]
    properties = [p["uid"] for p in data["properties"]]
    spaces = [s["uid"] for s in data["spaces"]]

    # index theorems by the properties they mention (like ImplicationIndex)
    by_prop = defaultdict(list)
    for t in theorems:
        for p in {a[0] for a in atoms(t["when"])} | {a[0] for a in atoms(t["then"])}:
            by_prop[p].append(t)

    asserted = defaultdict(dict)   # space -> {prop: value}
    for tr in data["traits"]:
        asserted[tr["space"]][tr["property"]] = tr["value"]

    n_asserted = sum(len(v) for v in asserted.values())
    n_derived = 0
    n_open = 0
    inconsistent = []
    open_questions = []

    for s in spaces:
        seed = asserted.get(s, {})
        known, contra = close_space(seed, by_prop, theorems)
        if contra:
            inconsistent.append((s, contra))
        derived = len(known) - len(seed)
        n_derived += derived
        for p in properties:
            if p not in known:
                n_open += 1
                open_questions.append((s, p))

    total_cells = len(spaces) * len(properties)
    decided = n_asserted + n_derived
    print(f"spaces × properties = {len(spaces)} × {len(properties)} = {total_cells} cells")
    print(f"  asserted (need a Lean trait proof): {n_asserted}")
    print(f"  derived  (free from theorem lemmas): {n_derived}")
    print(f"  decided total:                       {decided}  ({100*decided//total_cells}%)")
    print(f"  open questions (Unknown):            {n_open}")
    print(f"  inconsistencies:                     {len(inconsistent)}")
    if inconsistent:
        for s, t in inconsistent[:10]:
            print(f"    !! {s} contradicts via {t}")

    if "--questions" in sys.argv:
        idx = sys.argv.index("--questions")
        n = int(sys.argv[idx + 1]) if len(sys.argv) > idx + 1 else 20
        pname = {p["uid"]: p["name"] for p in data["properties"]}
        sname = {s["uid"]: s["name"] for s in data["spaces"]}
        print(f"\nsample open questions (does the space satisfy the property?):")
        for s, p in open_questions[:n]:
            print(f"  {s} «{sname[s]}»  ⊨?  {p} «{pname[p]}»")


if __name__ == "__main__":
    main()

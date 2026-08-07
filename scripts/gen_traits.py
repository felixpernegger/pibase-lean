#!/usr/bin/env python3
"""
gen_traits.py — generate each space's trait table in Lean, the pi-base way.

For every space we know a few *asserted* traits (human-entered, source-cited in
pi-base); the rest of its trait table is *derived* by pi-base's deduction engine
from the theorems. This script replays that deduction using ONLY the theorems
Felix has already formalized (his `T<n> : Pa ≤ Pb`) over the properties he has
(`P<n> : Property`), so that:

  * a derived trait becomes a one-line Lean proof: apply the theorem to the space
    and the prerequisite trait proofs — `T<k> S<n> inferInstance <prereqs>`;
  * an asserted trait becomes a proof obligation (`sorry`) — the real work, and
    exactly the counterexample data that refutes implications.

Phase 1 here: load the data, map Felix's available theorems/properties, run the
deriving closure per space, and report the shape of the work. Lean emission is
gated behind --emit.

Usage:  python3 scripts/gen_traits.py                # stats
        python3 scripts/gen_traits.py --emit S3      # print the Lean for one space
"""
import json
import os
import re
import sys
from collections import defaultdict

REPO = "/Users/jack/Desktop/LEAN/pibase-lean"
PIBASE_JSON = "/Users/jack/Desktop/LEAN/pi-base-lean/data/pibase.json"


def atoms(f):
    if f["kind"] == "atom":
        yield (f["property"], f["value"])
    else:
        for s in f["subs"]:
            yield from atoms(s)


def eval3(f, known):
    """Three-valued (Kleene) truth of formula f against the partial map `known`."""
    k = f["kind"]
    if k == "atom":
        v = known.get(f["property"])
        return None if v is None else (v == f["value"])
    vals = [eval3(s, known) for s in f["subs"]]
    if k == "and":
        if any(v is False for v in vals):
            return False
        return True if all(v is True for v in vals) else None
    else:  # or
        if any(v is True for v in vals):
            return True
        return False if all(v is False for v in vals) else None


def close(seed, theorems, availP):
    """pi-base forward chaining + contrapositive, restricted to available props.
    Returns known:{prop->bool}, deriv:{prop->(kind,thm_uid,prereqs)}, order:[prop]."""
    known = {p: v for p, v in seed.items() if p in availP}
    deriv = {p: ("asserted", None, []) for p in known}
    order = list(known)
    changed = True
    while changed:
        changed = False
        for T in theorems:
            A, C = T["when"], T["then"]
            av, cv = eval3(A, known), eval3(C, known)
            if av is True and cv is not True:            # modus ponens → force C
                for p, v in atoms(C):
                    if p in availP and p not in known:
                        known[p] = v
                        deriv[p] = ("mp", T["uid"], list(atoms(A)))
                        order.append(p); changed = True
            if cv is False and av is not False:          # contrapositive → force ¬A
                aa = list(atoms(A))
                unknown = [(p, v) for p, v in aa if p not in known]
                if len(unknown) == 1:
                    p, v = unknown[0]
                    others = [(q, w) for q, w in aa if q in known]
                    if p in availP and all(known[q] == w for q, w in others):
                        known[p] = (not v)
                        deriv[p] = ("cp", T["uid"], list(atoms(C)) + others)
                        order.append(p); changed = True
    return known, deriv, order


def main():
    data = json.load(open(PIBASE_JSON))
    theorems = data["theorems"]
    pname = {p["uid"]: p["name"] for p in data["properties"]}
    sname = {s["uid"]: s["name"] for s in data["spaces"]}
    seeds = defaultdict(dict)
    for t in data["traits"]:
        seeds[t["space"]][t["property"]] = t["value"]

    # Felix's formalized properties / theorems (his short ids → pi-base uids)
    def avail(kind):
        d = os.path.join(REPO, "PiBaseLean", {"P": "Properties", "T": "Theorems"}[kind])
        out = set()
        for name in os.listdir(d):
            m = re.fullmatch(rf"{kind}(\d+)", name)
            if m:
                out.add(f"{kind}{int(m.group(1)):06d}")
        return out

    availP, availT = avail("P"), avail("T")
    avail_theorems = [t for t in theorems if t["uid"] in availT]

    # spaces Felix has (so far) — Spaces/S<n> dirs that compiled
    have_space = set()
    sp_dir = os.path.join(REPO, "PiBaseLean", "Spaces")
    if os.path.isdir(sp_dir):
        for name in os.listdir(sp_dir):
            m = re.fullmatch(r"S(\d+)", name)
            if m:
                have_space.add(f"S{int(m.group(1)):06d}")

    if "--emit" in sys.argv:
        want = sys.argv[sys.argv.index("--emit") + 1]
        uid = f"S{int(want.lstrip('Ss')):06d}"
        print(emit_space(uid, seeds[uid], avail_theorems, availP, pname, sname))
        return

    if "--data" in sys.argv:
        # per-space trait table for the review UI: property, value, and how it's known
        out = {}
        for suid in sorted(seeds):
            known, deriv, order = close(seeds[suid], avail_theorems, availP)
            rows = []
            for p in order:
                kind, thm, _ = deriv[p]
                status = ("asserted" if kind == "asserted"
                          else ("proven" if (kind == "mp" and known[p]) else "derivable"))
                rows.append({"property": p, "name": pname.get(p, p), "value": known[p],
                             "status": status, "via": (f"T{int(thm[1:])}" if thm else None)})
            out[suid] = {"name": sname.get(suid, ""), "traits": rows}
        dest = os.path.join(REPO, "data", "traits.json")
        os.makedirs(os.path.dirname(dest), exist_ok=True)
        json.dump(out, open(dest, "w"), ensure_ascii=False, indent=0)
        tot = sum(len(v["traits"]) for v in out.values())
        print(f"wrote data/traits.json: {len(out)} spaces, {tot} trait cells")
        return

    # ---- stats ----
    tot_ass = tot_der = tot_cells = 0
    per = []
    for suid in sorted(seeds):
        known, deriv, order = close(seeds[suid], avail_theorems, availP)
        ass = sum(1 for p in known if deriv[p][0] == "asserted")
        der = len(known) - ass
        tot_ass += ass; tot_der += der; tot_cells += len(known)
        per.append((suid, len(known), ass, der))
    print(f"pi-base data: {len(seeds)} spaces, {len(data['traits'])} asserted traits")
    print(f"Felix formalized: {len(availP)} properties, {len(availT)} theorems, "
          f"{len(have_space)} space dirs present")
    print(f"\nOver Felix's {len(availP)} properties, replaying his {len(availT)} theorems:")
    print(f"  trait cells determined:  {tot_cells}")
    print(f"  ├─ derivable in Lean (one-liners off his ≤ theorems): {tot_der}  "
          f"({100*tot_der//max(tot_cells,1)}%)")
    print(f"  └─ asserted (need a direct proof; negatives are the hard ones): {tot_ass}  "
          f"({100*tot_ass//max(tot_cells,1)}%)")
    print(f"\nper-space sample (space: cells = asserted + derived):")
    for suid, n, a, d in per[:12]:
        print(f"  {suid} «{sname.get(suid,'')[:34]:36}» {n:3} = {a} asserted + {d} derived")


import json as _json
_CARRIERS = _json.load(open("/Users/jack/Desktop/LEAN/pibase-source-data/carriers.json")) \
    if os.path.exists("/Users/jack/Desktop/LEAN/pibase-source-data/carriers.json") else {}


def _tname(n, q, w):
    """Local trait-theorem name for property q (value w) on space S<n>."""
    return f"S{n}_P{int(q[1:])}" + ("" if w else "_not")


def emit_space(uid, seed, theorems, availP, pname, sname):
    """Lean emission for one space's trait table: derived traits as one-line proofs
    off Felix's ≤ theorems, asserted traits as `sorry` obligations."""
    known, deriv, order = close(seed, theorems, availP)
    n = int(uid[1:])
    C = _CARRIERS.get(f"S{n}", f"S{n}")               # fully-qualified carrier type
    na = sum(1 for p in known if deriv[p][0] == 'asserted')
    lines = [f"/-! Traits for π-Base {uid} «{sname.get(uid,'')}»  — carrier `{C}`.",
             f"    {na} asserted (`sorry`) + {len(known)-na} derived off the ≤ theorems. -/",
             "open PiBase.Formal"]
    for p in order:
        v = known[p]; pn = int(p[1:])
        P = f"P{pn}"; goal = f"{P} {C}" if v else f"¬ {P} {C}"
        kind, thm, pre = deriv[p]
        nm = _tname(n, p, v)
        if kind == "asserted":
            lines.append(f"theorem {nm} : {goal} := sorry  -- ASSERTED «{pname.get(p,'')}»")
        elif kind == "mp" and v:
            tk = int(thm[1:])
            refs = [_tname(n, q, w) for q, w in pre]
            payload = refs[0] if len(refs) == 1 else "⟨" + ", ".join(refs) + "⟩"
            lines.append(f"theorem {nm} : {goal} := T{tk} {C} inferInstance {payload}"
                         f"  -- «{pname.get(p,'')}» via T{tk}")
        else:
            # contrapositive / other: mechanizable, but proof-term construction is
            # subtler (negative-antecedent bookkeeping); left as an obligation.
            lines.append(f"theorem {nm} : {goal} := sorry  -- {kind} T{int(thm[1:])} «{pname.get(p,'')}» (derivable)")
    return "\n".join(lines)


if __name__ == "__main__":
    main()

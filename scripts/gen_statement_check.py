#!/usr/bin/env python3
"""Generate `PiBaseLean/StatementCheck.lean` from the pinned π-base snapshot.

Formalizing theorem `T<n>` means proving the implication that π-base records under
uid `T<n>` -- not merely declaring *some* true theorem under that name. Nothing in
the build enforced that correspondence, so a formalization could drift away from
its uid (because the upstream statement was restated, or because it was read off
the prose rather than the formula) and still be reported as complete.

This script closes the loop. For every formalized theorem it emits

    example : <statement read from the snapshot> := T<n>

into `PiBaseLean/StatementCheck.lean`. The Lean build then rejects any `T<n>`
whose type is not the π-base implication for that uid, so the correspondence is
checked by the kernel rather than by a name match.

Usage:
    python3 scripts/gen_statement_check.py            # rewrite the generated file
    python3 scripts/gen_statement_check.py --check    # fail if it is out of date
"""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SNAPSHOT = ROOT / "data" / "pibase.json"
THEOREMS = ROOT / "PiBaseLean" / "Theorems"
OUTPUT = ROOT / "PiBaseLean" / "StatementCheck.lean"

ISSUE_URL = "https://github.com/felixpernegger/pibase-lean/issues/1324"

# Theorems whose Lean statement does not match the uid it is filed under, mapping
#
#   uid -> (what the Lean file proves, what the snapshot records)
#
# Such a theorem is excluded from the generated file, so it is checked by nothing; the
# table exists so that a disagreement can be recorded and worked off rather than silently
# tolerated. Every run audits it: an entry whose theorem now agrees with the snapshot fails
# with a request to delete it, so a fix cannot be left uncovered, and an entry whose
# recorded statements have gone stale fails too.
#
# Empty is the goal state, and is the state today: the nine disagreements reported in the
# issue below were fixed rather than quarantined.
QUARANTINE: dict[str, tuple[str, str]] = {}


def short(uid: str) -> str:
    """`P000016` -> `P16`, matching the Lean naming."""
    return f"{uid[0]}{int(uid[1:])}"


def atoms(formula: dict) -> list[tuple[str, bool]] | None:
    """Flatten a π-base formula to `[(property, value)]`, or `None` if not a conjunction of atoms."""
    if formula["kind"] == "atom":
        return [(short(formula["property"]), formula["value"])]
    if formula["kind"] == "and":
        out: list[tuple[str, bool]] = []
        for sub in formula["subs"]:
            flat = atoms(sub)
            if flat is None:
                return None
            out += flat
        return out
    return None


def literal(prop: str, value: bool) -> str:
    """A π-base atom as a `Property`: negation is complementation in the lattice."""
    return prop if value else f"{prop}ᶜ"


def snapshot_statements() -> dict[str, tuple[list[str], str]]:
    """Every Horn implication in the snapshot, keyed by short uid."""
    data = json.loads(SNAPSHOT.read_text(encoding="utf-8"))
    book: dict[str, tuple[list[str], str]] = {}
    for theorem in data["theorems"]:
        hypotheses, conclusion = atoms(theorem["when"]), atoms(theorem["then"])
        if hypotheses and conclusion and len(conclusion) == 1:
            book[short(theorem["uid"])] = (
                [literal(*atom) for atom in hypotheses],
                literal(*conclusion[0]),
            )
    return book


def formalized() -> list[tuple[str, Path]]:
    """Every `PiBaseLean/Theorems/T<n>/Theorem.lean` that declares `theorem T<n>`, in uid order."""
    found: list[tuple[str, Path]] = []
    for path in THEOREMS.glob("T*/Theorem.lean"):
        uid = path.parent.name
        if re.search(rf"\btheorem\s+{uid}\b", path.read_text(encoding="utf-8")):
            found.append((uid, path))
    return sorted(found, key=lambda item: int(item[0][1:]))


def lean_statement(path: Path) -> tuple[list[str], str] | None:
    """The bundled `T<n> : lhs ≤ rhs` of a theorem file, as `([lhs literals], rhs)`."""
    match = re.search(r"\btheorem\s+T\d+\s*:\s*(.*?)\s*:=", path.read_text(encoding="utf-8"), re.S)
    if not match:
        return None
    statement = " ".join(match.group(1).split())
    if "≤" not in statement:
        return None
    lhs, rhs = statement.split("≤", 1)
    return [part.strip() for part in lhs.split("⊓")], rhs.strip()


def audit_quarantine(book: dict[str, tuple[list[str], str]], theorems: list[tuple[str, Path]]) -> list[str]:
    """Complaints about `QUARANTINE` entries that no longer describe reality.

    A quarantined theorem is excluded from the kernel check, so the list has to be kept
    honest by hand. These checks do that: an entry whose theorem now matches the snapshot
    must be removed (otherwise the fix is not actually verified by anything), and an entry
    whose recorded statements have gone stale is no longer evidence of anything.
    """
    paths = dict(theorems)
    complaints = []
    for uid, (recorded_lean, recorded_data) in sorted(QUARANTINE.items(), key=lambda kv: int(kv[0][1:])):
        if uid not in paths:
            complaints.append(f"{uid} is quarantined but no longer formalized; drop it from QUARANTINE.")
            continue
        actual = lean_statement(paths[uid])
        if actual is None:
            complaints.append(f"{uid} is quarantined but its statement could not be parsed.")
            continue
        expected = book.get(uid)
        if expected is None:
            complaints.append(f"{uid} is quarantined but has no Horn implication in the snapshot.")
            continue
        show = lambda pair: f"{' ⊓ '.join(pair[0])} ≤ {pair[1]}"
        if actual == expected:
            complaints.append(
                f"{uid} now matches the snapshot ({show(actual)}). Remove it from QUARANTINE "
                f"and regenerate, so that the check covers it."
            )
            continue
        if show(actual) != recorded_lean or show(expected) != recorded_data:
            complaints.append(
                f"{uid} no longer matches its QUARANTINE record.\n"
                f"    recorded lean: {recorded_lean}\n"
                f"    actual lean:   {show(actual)}\n"
                f"    recorded data: {recorded_data}\n"
                f"    actual data:   {show(expected)}"
            )
    return complaints


def render(book: dict[str, tuple[list[str], str]], theorems: list[tuple[str, Path]]) -> str:
    checked = [(uid, book[uid]) for uid, _ in theorems if uid in book and uid not in QUARANTINE]

    properties = sorted(
        {re.sub(r"ᶜ$", "", part) for _, (lhs, rhs) in checked for part in [*lhs, rhs]},
        key=lambda name: int(name[1:]),
    )

    lines = [
        "module",
        "",
        "/-",
        "  DO NOT EDIT. Generated by `scripts/gen_statement_check.py` from `data/pibase.json`.",
        "  Regenerate with `python3 scripts/gen_statement_check.py`.",
        "-/",
        "",
    ]
    lines.append("public import PiBaseLean.Bundled.Basic")
    lines += [f"public import PiBaseLean.Properties.{name}.Bundled" for name in properties]
    lines += [f"public import PiBaseLean.Theorems.{uid}.Theorem" for uid, _ in checked]
    lines += [
        "",
        "/-!",
        "# Statements checked against the π-base snapshot",
        "",
        "Each `example` below restates, directly from `data/pibase.json`, the implication that",
        "π-base records under a given uid, and discharges it with the formalization filed under",
        "that uid. A `T<n>` whose type is not π-base's `T<n>` fails to elaborate here, so the",
        "correspondence between this library and the database is checked by the kernel.",
        "",
        "This file is generated. To extend it, formalize a theorem; it is picked up automatically.",
        "",
        f"{len(QUARANTINE)} formalized theorems are deliberately absent: their statements disagree",
        f"with the uid they are filed under, and are being resolved separately. They are listed,",
        f"with both statements, in `scripts/gen_statement_check.py`. See {ISSUE_URL}.",
        "-/",
        "",
        "namespace PiBase.Formal",
        "",
    ]
    for uid, (lhs, rhs) in checked:
        lines.append(f"example : {' ⊓ '.join(lhs)} ≤ {rhs} := {uid}")
    lines += ["", "end PiBase.Formal", ""]
    return "\n".join(lines)


def quarantine_report() -> str:
    """The quarantine, spelled out.

    A quarantined theorem is excluded from the generated file, so it contributes nothing to
    a passing run. Saying only that the check passed invites reading a green build as "every
    formalized theorem agrees with pi-base", which is exactly what is not true while this
    list is non-empty. So the list is printed in full, every run, pass or fail.
    """
    if not QUARANTINE:
        return "No theorems are quarantined: every formalized theorem is checked."
    lines = [
        "",
        f"NOT CHECKED: {len(QUARANTINE)} formalized theorems are excluded because their",
        f"statement disagrees with the uid they are filed under. These are still wrong in the",
        f"source; a passing run says nothing about them. See {ISSUE_URL}.",
        "",
    ]
    width = max(len(uid) for uid in QUARANTINE)
    for uid, (lean, data) in sorted(QUARANTINE.items(), key=lambda kv: int(kv[0][1:])):
        lines.append(f"  {uid:<{width}}  proves {lean}")
        lines.append(f"  {'':<{width}}  pi-base says {data}")
    return "\n".join(lines)


def main() -> int:
    book = snapshot_statements()
    theorems = formalized()

    unknown = [uid for uid, _ in theorems if uid not in book]
    if unknown:
        print(
            "These theorems have no Horn implication in the snapshot, so they cannot be checked.\n"
            "Either the snapshot is stale or the uid does not exist upstream:\n  "
            + ", ".join(unknown),
            file=sys.stderr,
        )
        return 1

    complaints = audit_quarantine(book, theorems)
    if complaints:
        print("QUARANTINE is out of date:\n  " + "\n  ".join(complaints), file=sys.stderr)
        return 1

    rendered = render(book, theorems)
    checked = sum(1 for uid, _ in theorems if uid not in QUARANTINE)

    if "--check" in sys.argv:
        current = OUTPUT.read_text(encoding="utf-8") if OUTPUT.exists() else ""
        if current != rendered:
            print(
                f"{OUTPUT.relative_to(ROOT)} is out of date.\n"
                "Run `python3 scripts/gen_statement_check.py` and commit the result.",
                file=sys.stderr,
            )
            return 1
        print(f"{OUTPUT.relative_to(ROOT)} is up to date: {checked} statements checked.")
        print(quarantine_report())
        return 0

    OUTPUT.write_text(rendered, encoding="utf-8")
    print(f"Wrote {OUTPUT.relative_to(ROOT)}: {checked} statements checked.")
    print(quarantine_report())
    return 0


if __name__ == "__main__":
    sys.exit(main())

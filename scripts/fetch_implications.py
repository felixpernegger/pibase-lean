#!/usr/bin/env python3
"""Refresh data/implications.json from felixpernegger/pibase-data.

Runs Felix's own site build (build_site.py) inside a checkout of that
repository so the payload — clauses, counterexample models, accepted
assertions, and the open list — is produced by the canonical engine rather
than a re-implementation. The dashboard's Implications page replays this
payload in the browser (dashboard/src/engine.ts).

Usage:
  python3 scripts/fetch_implications.py [path-to-pibase-data-checkout]

Without an argument the checkout is taken from $PIBASE_DATA_SOURCE, or the
repository is cloned into a temporary directory (requires network access).
Felix's build needs PyYAML.
"""

from __future__ import annotations

import json
import os
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SCRIPTS = ROOT / "scripts"
sys.path.insert(0, str(SCRIPTS))

from build_dashboard_data import validate_implications  # noqa: E402

REPO_SLUG = "felixpernegger/pibase-data"
TARGET = ROOT / "data" / "implications.json"


def build_payload(source: Path) -> dict:
    if not (source / "build_site.py").is_file():
        raise SystemExit(f"{source} does not look like a pibase-data checkout (no build_site.py)")
    env = dict(os.environ, GITHUB_REPOSITORY=REPO_SLUG, PYTHONDONTWRITEBYTECODE="1")
    subprocess.run([sys.executable, "build_site.py"], cwd=source, env=env, check=True)
    with (source / "_site" / "data.json").open(encoding="utf-8") as handle:
        return json.load(handle)


def main() -> None:
    argument = sys.argv[1] if len(sys.argv) > 1 else os.environ.get("PIBASE_DATA_SOURCE", "")
    if argument:
        payload = build_payload(Path(argument).resolve())
    else:
        with tempfile.TemporaryDirectory(prefix="pibase-data-") as scratch:
            subprocess.run(
                ["git", "clone", "--depth", "1", f"https://github.com/{REPO_SLUG}.git", scratch],
                check=True,
            )
            payload = build_payload(Path(scratch))
    validate_implications(payload)
    with TARGET.open("w", encoding="utf-8") as handle:
        json.dump(payload, handle, ensure_ascii=False, separators=(",", ":"))
    print(
        f"wrote {TARGET.relative_to(ROOT)}: {payload['counts']['unknown']} open, "
        f"{len(payload['assertions'])} accepted assertions, {len(payload['clauses'])} clauses"
    )


if __name__ == "__main__":
    main()

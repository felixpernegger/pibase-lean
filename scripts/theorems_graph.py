#!/usr/bin/env python3
"""
theorems_graph.py — plot the number of subdirectories in PiBaseLean/Theorems over time.

Usage:
    python scripts/theorems_graph.py [--start YYYY-MM-DD] [--output PATH]

On first run it collects data from git history and caches it to
scripts/theorems_data.csv. Subsequent runs only fetch new dates.
"""

import argparse
import csv
import os
import subprocess
import sys
from datetime import date, timedelta
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
THEOREMS_PATH = "PiBaseLean/Theorems"
DATA_CSV = Path(__file__).resolve().parent / "theorems_data.csv"
DEFAULT_START = date(2026, 4, 4)
DEFAULT_OUTPUT = Path(__file__).resolve().parent / "theorems_growth.png"


def git(*args, cwd=REPO_ROOT):
    result = subprocess.run(
        ["git"] + list(args),
        cwd=cwd,
        capture_output=True,
        text=True,
    )
    return result.stdout.strip()


def git_fetch():
    print("Running git fetch…")
    result = subprocess.run(["git", "fetch"], cwd=REPO_ROOT, capture_output=True, text=True)
    if result.returncode == 0:
        print("  fetch OK")
    else:
        print(f"  fetch warning: {result.stderr.strip()}")


def commit_at(day: date) -> str:
    """Return the last commit hash whose date is strictly before midnight UTC of the given day."""
    timestamp = f"{day.isoformat()} 00:00:00 +0000"
    return git("rev-list", "-n", "1", f"--before={timestamp}", "HEAD")


def count_folders(commit: str) -> int:
    if not commit:
        return 0
    output = git("ls-tree", "--name-only", commit, f"{THEOREMS_PATH}/")
    if not output:
        return 0
    return len([line for line in output.splitlines() if line.strip()])


def load_cache() -> dict:
    data = {}
    if DATA_CSV.exists():
        with open(DATA_CSV, newline="") as f:
            for row in csv.DictReader(f):
                data[row["date"]] = int(row["count"])
    return data


def save_cache(data: dict):
    with open(DATA_CSV, "w", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=["date", "count"])
        writer.writeheader()
        for d in sorted(data.keys()):
            writer.writerow({"date": d, "count": data[d]})


def collect(start: date) -> dict:
    today = date.today()
    data = load_cache()

    days = []
    d = start
    while d <= today:
        if d.isoformat() not in data:
            days.append(d)
        d += timedelta(days=1)

    if days:
        print(f"Fetching data for {len(days)} new date(s)…")
        for d in days:
            commit = commit_at(d)
            count = count_folders(commit)
            data[d.isoformat()] = count
            print(f"  {d}  commit={commit[:8] if commit else 'none':8s}  folders={count}")
        save_cache(data)
        print(f"Saved to {DATA_CSV}")
    else:
        print("Cache is up to date — no new dates to fetch.")

    return data


def plot(data: dict, start: date, output: Path):
    try:
        import matplotlib.pyplot as plt
        import matplotlib.dates as mdates
    except ImportError:
        print("matplotlib is not installed. Run: pip install matplotlib")
        sys.exit(1)

    from datetime import datetime

    items = sorted(
        (date.fromisoformat(k), v)
        for k, v in data.items()
        if date.fromisoformat(k) >= start
    )
    if not items:
        print("No data to plot.")
        return

    dates, counts = zip(*items)
    dt_dates = [datetime(d.year, d.month, d.day) for d in dates]

    fig, ax = plt.subplots(figsize=(12, 5))
    ax.plot(dt_dates, counts, color="steelblue", linewidth=1.8, marker="o", markersize=4)
    ax.fill_between(dt_dates, counts, alpha=0.12, color="steelblue")

    ax.set_title("Theorems folders over time", fontsize=14, fontweight="bold")
    ax.set_xlabel("Date (00:00 UTC snapshot)")
    ax.set_ylabel("Number of folders")
    ax.yaxis.get_major_locator().set_params(integer=True)

    ax.xaxis.set_major_locator(mdates.DayLocator(interval=2))
    ax.xaxis.set_major_formatter(mdates.DateFormatter("%b %d"))
    plt.xticks(rotation=45, ha="right")

    ax.grid(axis="y", linestyle="--", alpha=0.5)
    ax.set_xlim(dt_dates[0], dt_dates[-1])
    ax.set_ylim(bottom=0)

    fig.tight_layout()
    fig.savefig(output, dpi=150)
    print(f"Saved plot to {output}")
    plt.show()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--start",
        default=DEFAULT_START.isoformat(),
        metavar="YYYY-MM-DD",
        help=f"Start date (default: {DEFAULT_START})",
    )
    parser.add_argument(
        "--output",
        default=str(DEFAULT_OUTPUT),
        metavar="PATH",
        help=f"Output PNG path (default: {DEFAULT_OUTPUT})",
    )
    args = parser.parse_args()

    start = date.fromisoformat(args.start)
    output = Path(args.output)

    git_fetch()
    data = collect(start)
    plot(data, start, output)


if __name__ == "__main__":
    main()

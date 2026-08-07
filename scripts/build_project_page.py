#!/usr/bin/env python3
"""
build_project_page.py - generate the static project landing page.

The page is intentionally close in shape to the Equational Theories Project
front page: title, compact link row, a real graph visual, current statistics,
and a short set of project links.

Reads:  data/pibase.json, data/coverage.json, data/questions.json,
        optionally PIBASE_LEAN_SOURCE=/path/to/pibase-lean
Writes: site/index.html, site/data.html, site/blueprint.html,
        site/assets/implication-map.png

Usage:  python3 scripts/build_project_page.py
"""
import html
import json
import os
import subprocess
import struct
import sys
import zlib
from collections import defaultdict
from pathlib import Path

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(ROOT, "scripts"))

from graph import full_trait_matrix, known_true_edges, transitive_closure  # noqa: E402

DATA = os.path.join(ROOT, "data", "pibase.json")
COVERAGE = os.path.join(ROOT, "data", "coverage.json")
QUESTIONS = os.path.join(ROOT, "data", "questions.json")
INDEPENDENCE = os.path.join(ROOT, "data", "independence.json")
SITE = os.path.join(ROOT, "site")
ASSETS = os.path.join(SITE, "assets")
OUT = os.path.join(SITE, "index.html")
BLUEPRINT_OUT = os.path.join(SITE, "blueprint.html")
DATA_OUT = os.path.join(SITE, "data.html")
GRAPH_PNG = os.path.join(ASSETS, "implication-map.png")

REPO = "https://github.com/felixpernegger/pibase-lean"
SOURCE_REPO = REPO
PIBASE = "https://topology.pi-base.org"
# The merged dashboard hosts the open-implications workflow itself.
OPEN_APP = "index.html#/implications"
ETP = "https://teorth.github.io/equational_theories/"
PIBASE_LEAN_SOURCE = os.environ.get(
    "PIBASE_LEAN_SOURCE",
    os.environ.get("FELIX_REPO_PATH", ROOT),
)
try:
    SOURCE_REF = (
        os.environ.get("PIBASE_LEAN_SOURCE_REF")
        or subprocess.check_output(
            ["git", "-C", PIBASE_LEAN_SOURCE, "rev-parse", "HEAD"],
            text=True,
            stderr=subprocess.DEVNULL,
        ).strip()
        or "master"
    )
except Exception:
    SOURCE_REF = "master"
REPO_BLOB = f"{SOURCE_REPO}/blob/{SOURCE_REF}"
SET_THEORY_FRONTIER_PROPERTIES = {
    "P000164": "Cardinality less than every measurable cardinal",
}


def comma(n):
    return f"{n:,}"


def pct(n, total):
    if not total:
        return "0.0%"
    return f"{100 * n / total:.1f}%"


def bounded_pct_value(n, total):
    if not total:
        return 0
    return max(0, min(100, 100 * n / total))


def git_value(path, *args):
    try:
        return subprocess.check_output(
            ["git", "-C", str(path), *args],
            text=True,
            stderr=subprocess.DEVNULL,
        ).strip()
    except Exception:
        return ""


def count_sorries(paths):
    total = 0
    for path in paths:
        try:
            total += path.read_text(encoding="utf-8").count("sorry")
        except UnicodeDecodeError:
            total += path.read_text(errors="ignore").count("sorry")
    return total


def formal_status(coverage):
    """Formal progress from the Lean tree used to build this page.

    If the Lean checkout is unavailable, fall back to this site's older
    coverage artifact so local generation still works.
    """
    source = Path(PIBASE_LEAN_SOURCE).resolve()
    properties_dir = source / "PiBaseLean" / "Properties"
    theorems_dir = source / "PiBaseLean" / "Theorems"

    if properties_dir.exists() and theorems_dir.exists():
        property_dirs = sorted(
            p for p in properties_dir.iterdir()
            if p.is_dir() and p.name.startswith("P") and p.name[1:].isdigit()
        )
        theorem_dirs = sorted(
            p for p in theorems_dir.iterdir()
            if p.is_dir() and p.name.startswith("T") and p.name[1:].isdigit()
        )
        property_files = sorted(properties_dir.glob("P*/*.lean"))
        theorem_files = sorted(theorems_dir.glob("T*/Theorem.lean"))
        property_lemma_files = sorted(properties_dir.glob("P*/Lemmas.lean"))
        property_sorry_files = [
            p for p in property_files if "sorry" in p.read_text(errors="ignore")
        ]
        theorem_sorry_files = [
            p for p in theorem_files if "sorry" in p.read_text(errors="ignore")
        ]
        commit = git_value(source, "rev-parse", "HEAD")
        commit_date = git_value(source, "log", "-1", "--format=%cI")
        return {
            "source_path": str(source),
            "source_label": "felixpernegger/pibase-lean",
            "source_url": SOURCE_REPO,
            "commit": commit,
            "commit_short": commit[:8] if commit else "unknown",
            "commit_date": commit_date[:10] if commit_date else "unknown",
            "property_entries": len(property_dirs),
            "theorem_entries": len(theorem_dirs),
            "property_files": len(property_files),
            "property_sorries": count_sorries(property_files),
            "property_files_with_sorry": len(property_sorry_files),
            "theorem_files": len(theorem_files),
            "theorem_sorries": count_sorries(theorem_files),
            "theorem_files_with_sorry": len(theorem_sorry_files),
            "property_lemma_files": len(property_lemma_files),
            "uses_felix_tree": True,
        }

    commit = git_value(ROOT, "rev-parse", "HEAD")
    commit_date = git_value(ROOT, "log", "-1", "--format=%cI")
    return {
        "source_path": str(source),
        "source_label": "local coverage artifact",
        "source_url": REPO,
        "commit": commit,
        "commit_short": commit[:8] if commit else "local",
        "commit_date": commit_date[:10] if commit_date else "local",
        "property_entries": coverage.get("properties_mapped", 0),
        "theorem_entries": coverage.get("theorems_proved", 0),
        "property_files": coverage.get("properties_mapped", 0),
        "property_sorries": 0,
        "property_files_with_sorry": 0,
        "theorem_files": coverage.get("theorems_proved", 0),
        "theorem_sorries": 0,
        "theorem_files_with_sorry": 0,
        "property_lemma_files": 0,
        "uses_felix_tree": False,
    }


def independence_status(questions):
    pairs = []
    payload = {}
    if os.path.exists(INDEPENDENCE):
        payload = json.load(open(INDEPENDENCE))
        if isinstance(payload, list):
            pairs = payload
            payload = {}
        else:
            pairs = payload.get("pairs", [])
    proven = {
        (item["hypothesis"], item["conclusion"])
        for item in pairs
        if item.get("hypothesis") and item.get("conclusion")
    }
    candidates = [
        q for q in questions["questions"]
        if q["hypothesis"] in SET_THEORY_FRONTIER_PROPERTIES
        or q["conclusion"] in SET_THEORY_FRONTIER_PROPERTIES
    ]
    return {
        "pairs": pairs,
        "proven_pairs": proven,
        "proven_count": len(proven),
        "conditional_space_ids": {
            item["space"]
            for item in payload.get("conditionalSpaces", [])
            if item.get("space")
        },
        "candidate_count": len(candidates),
        "candidates": candidates,
    }


def graph_status(data, independent_pairs=None, conditional_spaces=None):
    """Return implication-grid statistics and a dense status matrix.

    Matrix values:
      0 diagonal
      1 true by theorem/transitive closure
      2 false by separating space
      3 open
      4 dependent on named additional axioms
    """
    independent_pairs = independent_pairs or set()
    conditional_spaces = conditional_spaces or set()
    nodes = [p["uid"] for p in data["properties"]]
    matrix = full_trait_matrix(data)
    direct_edges = known_true_edges(data)
    reach = transitive_closure(direct_edges, nodes)
    node_set = set(nodes)
    explicitly_true = sum(
        1
        for p, qs in direct_edges.items()
        for q in qs
        if p in node_set and q in node_set and p != q
    )

    true_pairs = 0
    false_pairs = 0
    open_pairs = 0
    witness_count = defaultdict(int)
    status_rows = []

    for p in nodes:
        row = []
        for q in nodes:
            if p == q:
                row.append(0)
                continue
            if q in reach[p]:
                true_pairs += 1
                row.append(1)
                continue
            witness = None
            for s, known in matrix.items():
                if s in conditional_spaces:
                    continue
                if known.get(p) is True and known.get(q) is False:
                    witness = s
                    break
            if witness is None:
                if (p, q) in independent_pairs:
                    row.append(4)
                else:
                    open_pairs += 1
                    row.append(3)
            else:
                false_pairs += 1
                witness_count[witness] += 1
                row.append(2)

        status_rows.append(row)

    independent_count = sum(1 for row in status_rows for state in row if state == 4)
    return {
        "nodes": nodes,
        "total": len(nodes) * (len(nodes) - 1),
        "true": true_pairs,
        "explicitly_true": explicitly_true,
        "implicitly_true": true_pairs - explicitly_true,
        "false": false_pairs,
        "independent": independent_count,
        "open": open_pairs,
        "witness_count": dict(witness_count),
        "rows": status_rows,
    }


def color(hex_value):
    hex_value = hex_value.lstrip("#")
    return tuple(int(hex_value[i:i + 2], 16) for i in (0, 2, 4))


def fill_rect(pixels, width, height, x0, y0, x1, y1, rgb):
    x0 = max(0, min(width, x0))
    x1 = max(0, min(width, x1))
    y0 = max(0, min(height, y0))
    y1 = max(0, min(height, y1))
    r, g, b = rgb
    for y in range(y0, y1):
        start = (y * width + x0) * 3
        end = (y * width + x1) * 3
        pixels[start:end] = bytes((r, g, b)) * (x1 - x0)


def write_png_rgb(path, width, height, pixels):
    def chunk(kind, data):
        return (
            struct.pack(">I", len(data))
            + kind
            + data
            + struct.pack(">I", zlib.crc32(kind + data) & 0xFFFFFFFF)
        )

    rows = []
    stride = width * 3
    for y in range(height):
        rows.append(b"\x00" + bytes(pixels[y * stride:(y + 1) * stride]))
    png = (
        b"\x89PNG\r\n\x1a\n"
        + chunk(b"IHDR", struct.pack(">IIBBBBB", width, height, 8, 2, 0, 0, 0))
        + chunk(b"IDAT", zlib.compress(b"".join(rows), 9))
        + chunk(b"IEND", b"")
    )
    with open(path, "wb") as f:
        f.write(png)


def write_graph_png(rows, path):
    n = len(rows)
    cell = 3
    pad = 28
    side = n * cell
    width = side + pad * 2
    height = side + pad * 2
    pixels = bytearray(width * height * 3)

    palette = {
        0: color("#e5eadf"),
        1: color("#257a57"),
        2: color("#b85f4d"),
        3: color("#315f95"),
        4: color("#7d5aa6"),
    }
    fill_rect(pixels, width, height, 0, 0, width, height, color("#f7f9f4"))
    fill_rect(pixels, width, height, pad - 3, pad - 3, pad + side + 3, pad + side + 3, color("#28323a"))
    fill_rect(pixels, width, height, pad - 1, pad - 1, pad + side + 1, pad + side + 1, color("#eef2ea"))

    for y, row in enumerate(rows):
        py = pad + y * cell
        for x, state in enumerate(row):
            px = pad + x * cell
            fill_rect(pixels, width, height, px, py, px + cell, py + cell, palette[state])

    rule = color("#f7f9f4")
    for k in range(0, n + 1, 32):
        x = pad + k * cell
        y = pad + k * cell
        fill_rect(pixels, width, height, x, pad, x + 1, pad + side, rule)
        fill_rect(pixels, width, height, pad, y, pad + side, y + 1, rule)

    write_png_rgb(path, width, height, pixels)


def stat_card(value, label, note, css_class=""):
    return f"""
      <div class="stat {css_class}">
        <div class="value">{html.escape(value)}</div>
        <div class="label">{html.escape(label)}</div>
        <div class="note">{html.escape(note)}</div>
      </div>"""


def coverage_row(label, covered, total, note, css_class=""):
    width = bounded_pct_value(covered, total)
    return f"""
      <div class="coverage-row {css_class}">
        <div class="coverage-head">
          <b>{html.escape(label)}</b>
          <span>{comma(covered)} / {comma(total)} ({pct(covered, total)})</span>
        </div>
        <div class="meter" aria-hidden="true"><i style="--w:{width:.1f}%"></i></div>
        <p>{html.escape(note)}</p>
      </div>"""


def witness_rows(summary, data, limit=8):
    names = {s["uid"]: s["name"] for s in data["spaces"]}
    top = sorted(summary["witness_count"].items(), key=lambda kv: -kv[1])[:limit]
    max_count = max((count for _, count in top), default=1)
    rows = []
    for uid, count in top:
        width = 100 * count / max_count
        rows.append(f"""
          <li>
            <a href="{PIBASE}/spaces/{uid}">{uid}</a>
            <span>{html.escape(names.get(uid, uid))}</span>
            <b>{comma(count)}</b>
            <i style="--w:{width:.1f}%"></i>
          </li>""")
    return "\n".join(rows)


def question_rows(questions, limit=5):
    rows = []
    for q in questions[:limit]:
        hyp = html.escape(q["hypothesis_name"])
        concl = html.escape(q["conclusion_name"])
        hp = html.escape(q["hypothesis"])
        cp = html.escape(q["conclusion"])
        rows.append(f"""
          <li>
            <a href="{PIBASE}/properties/{hp}">{hp}</a>
            <span>{hyp}</span>
            <strong>&rarr;?</strong>
            <a href="{PIBASE}/properties/{cp}">{cp}</a>
            <span>{concl}</span>
          </li>""")
    return "\n".join(rows)


def slug(title):
    return "".join(c.lower() if c.isalnum() else "-" for c in title).strip("-")


def build_blueprint_page(data, coverage, questions, summary):
    counts = coverage["counts"]
    total = summary["total"]
    top_witnesses = sorted(summary["witness_count"].items(), key=lambda kv: -kv[1])[:6]
    space_names = {s["uid"]: s["name"] for s in data["spaces"]}
    witness_table = "\n".join(
        f"""<tr><td><a href="{PIBASE}/spaces/{uid}">{uid}</a></td><td>{html.escape(space_names.get(uid, uid))}</td><td>{comma(count)}</td></tr>"""
        for uid, count in top_witnesses
    )
    sample_questions = "\n".join(
        f"""<li><code>{html.escape(q["lean"])}</code><span>{html.escape(q["hypothesis_name"])} &rarr;? {html.escape(q["conclusion_name"])}</span></li>"""
        for q in questions["questions"][:6]
    )

    sections = [
        (
            "Overview",
            f"""
            <p>
              The <strong>pibase-lean</strong> blueprint describes a Lean 4 formalization
              of the pi-Base implication graph.  The object of study is the preorder on
              topological properties: for every ordered pair of properties
              <em>P</em> and <em>Q</em>, decide whether every space satisfying
              <em>P</em> also satisfies <em>Q</em>.
            </p>
            <p>
              The project follows the same pattern as the Equational Theories Project:
              keep the data canonical, generate the Lean interface, prove a compact
              generating set, and use external closure to make the full graph visible.
            </p>
            """,
        ),
        (
            "The Data",
            f"""
            <p>
              The pinned pi-Base snapshot supplies the finite universe for the graph.
              These numbers are read directly from <code>data/pibase.json</code> and
              <code>data/coverage.json</code>.
            </p>
            <table>
              <tr><th>entity</th><th>count</th><th>role</th></tr>
              <tr><td>properties</td><td>{comma(counts["properties"])}</td><td>nodes of the implication graph</td></tr>
              <tr><td>spaces</td><td>{comma(counts["spaces"])}</td><td>counterexample witnesses</td></tr>
              <tr><td>theorems</td><td>{comma(counts["theorems"])}</td><td>asserted implication rules</td></tr>
              <tr><td>traits</td><td>{comma(counts["traits"])}</td><td>asserted space-property facts</td></tr>
            </table>
            """,
        ),
        (
            "Formal Core",
            """
            <p>
              The core Lean layer is deliberately small. A topological property is a
              predicate on a type equipped with a <code>TopologicalSpace</code> instance;
              an implication is a universally quantified theorem between two such
              predicates; and a separating space packages a proof of <em>P X</em>
              together with a proof of <em>&not; Q X</em>.
            </p>
            <pre><code>TopProperty := (X : Type*) -&gt; [TopologicalSpace X] -&gt; Prop
Implies P Q := forall X [TopologicalSpace X], P X -&gt; Q X
Separates X P Q := P X and not Q X</code></pre>
            <p>
              A separating space gives the kernel-checked refutation
              <code>&not; Implies P Q</code>.
            </p>
            """,
        ),
        (
            "Lean Entries And Data",
            f"""
            <p>
              The site combines two views of the work: the checked Lean tree and the
              pinned pi-Base data snapshot under <code>data/</code>.
              The data artifacts describe the full {comma(counts["properties"])}-property
              implication graph; the Lean tree records which entries have actually
              been represented and where proof debt remains.
            </p>
            <p>
              The registry artifact maps pi-Base property identifiers to Mathlib
              predicates where that comparison is known. It currently maps
              {comma(coverage["properties_mapped"])} of
              {comma(coverage["properties_total"])} properties.
            </p>
            """,
        ),
        (
            "True Implications",
            f"""
            <p>
              There are {comma(summary["true"])} true implications in the current
              {comma(total)}-cell graph.  These are classifications from the pinned
              pi-Base theorem data, not counts of Lean-proved theorems.
              The distinction between explicit and implicit true implications mirrors
              the Equational Theories dashboard vocabulary.
            </p>
            <table>
              <tr><th>classification</th><th>count</th><th>meaning</th></tr>
              <tr><td>explicitly true</td><td>{comma(summary["explicitly_true"])}</td><td>direct theorem edges asserted by pi-Base</td></tr>
              <tr><td>implicitly true</td><td>{comma(summary["implicitly_true"])}</td><td>additional edges obtained by transitive closure</td></tr>
            </table>
            <p>
              The Lean formalization status is tracked separately: this scaffold has
              generated {comma(coverage["theorems_statement_generated"])} theorem
              statements, {comma(coverage["theorems_provable_now"])} are currently
              in the Tier-A/provable-now slice, and {comma(coverage["theorems_proved"])}
              are kernel-checked.
            </p>
            """,
        ),
        (
            "False Implications",
            f"""
            <p>
              A false implication is certified by a witness space.  The graph currently
              has {comma(summary["false"])} refuted implications, witnessed by concrete
              pi-Base spaces after closure of the space-property matrix.
            </p>
            <table>
              <tr><th>space</th><th>name</th><th>refuted edges</th></tr>
              {witness_table}
            </table>
            """,
        ),
        (
            "Open Frontier",
            f"""
            <p>
              The remaining {comma(summary["open"])} implication cells are neither
              proved by the theorem closure, refuted by a known separating space,
              nor certified as dependent on additional axioms. These are exported to
              <code>data/questions.json</code> as a machine-readable worklist.
            </p>
            <p>
              Dependence on a named axiom is a separate outcome category. The current
              site data records {comma(summary["independent"])} axiom-dependent
              implication pairs; set-theoretic candidates remain unclassified until a
              dependency certificate is added.
            </p>
            <ol class="questions">
              {sample_questions}
            </ol>
            """,
        ),
        (
            "Review And Trust",
            """
            <p>
              The review page places each informal pi-Base statement next to its Lean
              or Mathlib definition.  This separates compilation from faithfulness:
              the Lean object must typecheck, but the statement also has to mean what
              the pi-Base entry says.
            </p>
            <p>
              The intended gate is: generated statement frozen, no hidden axioms,
              no new <code>sorry</code>, and human review for semantic equivalence.
            </p>
            """,
        ),
        (
            "Roadmap",
            """
            <ol>
              <li>Grow the Mathlib registry for Tier-A topological properties.</li>
              <li>Formalize the highest-yield witness spaces first.</li>
              <li>Replace generated theorem stubs with kernel-checked proofs.</li>
              <li>Regenerate closure and questions after every proved edge or witness.</li>
              <li>Feed genuinely new answers back toward pi-Base.</li>
            </ol>
            """,
        ),
        (
            "Build Commands",
            """
            <pre><code>lake exe cache get
lake build
python3 scripts/gen_traits.py
python3 scripts/graph.py --witnesses
python3 scripts/build_review.py
python3 scripts/build_project_page.py</code></pre>
            """,
        ),
    ]

    toc = "\n".join(
        f'<li><a href="#{slug(title)}">{i}. {html.escape(title)}</a></li>'
        for i, (title, _) in enumerate(sections, 1)
    )
    rendered_sections = "\n".join(
        f"""<section id="{slug(title)}"><h2>{i}. {html.escape(title)}</h2>{body}</section>"""
        for i, (title, body) in enumerate(sections, 1)
    )

    return f"""<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>pibase-lean blueprint</title>
<meta name="description" content="Blueprint for the pibase-lean formalization project.">
<style>
:root {{
  --paper:#fbfcf8;
  --ink:#1d2328;
  --muted:#5d6670;
  --rule:#d8dfd3;
  --blue:#315f95;
  --panel:#ffffff;
  --code:#eef2ea;
}}
* {{ box-sizing:border-box; }}
html {{ scroll-behavior:smooth; }}
body {{
  margin:0;
  background:var(--paper);
  color:var(--ink);
  font:16px/1.62 ui-serif, Georgia, Cambria, "Times New Roman", serif;
}}
a {{ color:var(--blue); text-decoration-thickness:1px; text-underline-offset:3px; }}
.wrap {{
  display:grid;
  grid-template-columns:280px minmax(0, 820px);
  gap:42px;
  width:min(1180px, calc(100% - 32px));
  margin:0 auto;
  padding:34px 0 72px;
}}
aside {{
  position:sticky;
  top:24px;
  align-self:start;
  max-height:calc(100vh - 48px);
  overflow:auto;
  border-right:1px solid var(--rule);
  padding-right:22px;
  font:14px/1.45 ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
}}
.brand {{
  display:block;
  margin-bottom:14px;
  font-weight:800;
  color:var(--ink);
}}
nav a {{ color:var(--ink); }}
nav ol {{
  margin:16px 0 0;
  padding:0;
  list-style:none;
}}
nav li {{ margin:8px 0; }}
.side-links {{
  display:flex;
  flex-wrap:wrap;
  gap:8px 14px;
  margin-top:18px;
}}
main {{ min-width:0; }}
h1 {{
  margin:0 0 8px;
  font-size:42px;
  line-height:1.06;
  letter-spacing:0;
}}
.subtitle {{
  margin:0 0 28px;
  color:var(--muted);
  font-size:20px;
}}
section {{
  padding:26px 0;
  border-top:1px solid var(--rule);
}}
section:first-of-type {{ border-top:0; }}
h2 {{
  margin:0 0 12px;
  font-size:26px;
  line-height:1.2;
}}
p {{ margin:0 0 14px; max-width:76ch; }}
table {{
  width:100%;
  border-collapse:collapse;
  margin:14px 0;
  font:14px/1.45 ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
  background:var(--panel);
}}
th, td {{
  text-align:left;
  vertical-align:top;
  border:1px solid var(--rule);
  padding:9px 10px;
}}
th {{ background:#eef2ea; }}
pre {{
  margin:14px 0;
  padding:14px 16px;
  overflow:auto;
  background:var(--code);
  border:1px solid var(--rule);
  font:14px/1.5 "SF Mono", Menlo, Consolas, monospace;
}}
code {{ font-family:"SF Mono", Menlo, Consolas, monospace; }}
.questions {{
  margin:10px 0 0;
  padding-left:22px;
}}
.questions li {{
  margin:10px 0;
}}
.questions code {{
  display:block;
  margin-bottom:2px;
}}
@media (max-width:850px) {{
  .wrap {{ grid-template-columns:1fr; gap:12px; }}
  aside {{
    position:static;
    max-height:none;
    border-right:0;
    border-bottom:1px solid var(--rule);
    padding:0 0 18px;
  }}
  h1 {{ font-size:34px; }}
}}
</style>
</head>
<body>
<div class="wrap">
  <aside>
    <a class="brand" href="index.html">pibase-lean</a>
    <nav aria-label="Blueprint contents">
      <strong>Blueprint</strong>
      <ol>{toc}</ol>
    </nav>
    <div class="side-links">
      <a href="index.html">Home</a>
      <a href="data.html">Data</a>
      <a href="review.html">Review UI</a>
      <a href="{SOURCE_REPO}">GitHub</a>
    </div>
  </aside>
  <main>
    <h1>pibase-lean Blueprint</h1>
    <p class="subtitle">A web blueprint for formalizing pi-Base as a Lean-checked implication graph.</p>
    {rendered_sections}
  </main>
</div>
</body>
</html>
"""


def build_page(data, coverage, questions, summary, formal):
    counts = coverage["counts"]
    total = summary["total"]
    source_note = (
        f'Read from <a href="{formal["source_url"]}">{html.escape(formal["source_label"])}</a>'
        f' at commit <code>{html.escape(formal["commit_short"])}</code>'
        if formal["uses_felix_tree"]
        else "Read from the local coverage artifact"
    )
    lean_stats = "\n".join([
        stat_card(comma(formal["property_entries"]), "property entries",
                  f"P* directories; {comma(counts['properties'])} properties in pi-Base", "lean"),
        stat_card(comma(formal["theorem_entries"]), "theorem entries",
                  f"T* theorem folders; {comma(counts['theorems'])} pi-Base theorem rows", "true"),
        stat_card(comma(formal["property_sorries"]), "property-layer sorries",
                  f"in {comma(formal['property_files_with_sorry'])} property files", "open"),
        stat_card(comma(formal["theorem_sorries"]), "theorem-file sorries",
                  "tokens in PiBaseLean/Theorems/T*/Theorem.lean", "implicit"),
    ])
    outcome_stats = "\n".join([
        stat_card(comma(summary["true"]), "true",
                  f"{comma(summary['explicitly_true'])} explicit; {comma(summary['implicitly_true'])} by closure", "true"),
        stat_card(comma(summary["false"]), "false",
                  f"{pct(summary['false'], total)} refuted by known spaces", "false"),
        stat_card(comma(summary["independent"]), "axiom-dependent",
                  "certified dependency pairs", "independent"),
        stat_card(comma(summary["open"]), "unclassified",
                  f"{pct(summary['open'], total)} not yet classified", "open"),
    ])

    return f"""<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>pibase-lean | Lean formalization status</title>
<meta name="description" content="Lean formalization status for Felix Pernegger's pibase-lean project.">
<style>
:root {{
  --paper:#fbfcf8;
  --ink:#1d2328;
  --muted:#5d6670;
  --rule:#d8dfd3;
  --green:#257a57;
  --rust:#b85f4d;
  --blue:#315f95;
  --gold:#b98124;
  --panel:#ffffff;
  --code:#eef2ea;
}}
* {{ box-sizing:border-box; }}
body {{
  margin:0;
  background:var(--paper);
  color:var(--ink);
  font:16px/1.58 ui-serif, Georgia, Cambria, "Times New Roman", serif;
}}
a {{ color:var(--blue); text-decoration-thickness:1px; text-underline-offset:3px; }}
.page {{
  width:min(1080px, calc(100% - 32px));
  margin:0 auto;
  padding:34px 0 56px;
}}
.hero {{
  display:grid;
  grid-template-columns:minmax(0, 1fr) minmax(300px, 34%);
  gap:34px;
  align-items:start;
  padding-bottom:28px;
  border-bottom:1px solid var(--rule);
}}
.kicker {{
  margin:0 0 10px;
  color:var(--muted);
  font:700 13px/1.2 ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
  letter-spacing:.08em;
  text-transform:uppercase;
}}
h1 {{
  margin:0;
  font-size:46px;
  line-height:1.02;
  letter-spacing:0;
}}
.subtitle {{
  max-width:760px;
  margin:12px 0 18px;
  font-size:20px;
  line-height:1.45;
}}
.link-row {{
  display:flex;
  flex-wrap:wrap;
  gap:10px 18px;
  margin:20px 0 28px;
  font:600 15px/1.3 ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
}}
.link-row a {{ color:var(--ink); }}
.lede {{ max-width:760px; margin:0; }}
.source-card {{
  background:var(--panel);
  border:1px solid var(--rule);
  padding:16px;
  font:14px/1.45 ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
}}
.source-card h2 {{
  margin:0 0 10px;
  font:700 15px/1.2 ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
  text-transform:uppercase;
  letter-spacing:.06em;
}}
.source-card p {{ margin:0 0 10px; color:var(--muted); }}
.source-card code {{
  font-family:"SF Mono", Menlo, Consolas, monospace;
  color:var(--ink);
}}
.stats {{
  display:grid;
  grid-template-columns:repeat(4, minmax(0, 1fr));
  gap:1px;
  margin:28px 0;
  background:var(--rule);
  border:1px solid var(--rule);
}}
.stat {{
  min-height:118px;
  padding:16px 14px;
  background:var(--panel);
}}
.stat .value {{
  font:700 30px/1 ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
}}
.stat .label {{
  margin-top:9px;
  font:700 13px/1.2 ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
  text-transform:uppercase;
  letter-spacing:.06em;
}}
.stat .note {{
  margin-top:7px;
  color:var(--muted);
  font:13px/1.35 ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
  overflow-wrap:anywhere;
}}
.stat.lean .value {{ color:var(--gold); }}
.stat.true .value {{ color:var(--green); }}
.stat.implicit .value {{ color:#52906c; }}
.stat.false .value {{ color:var(--rust); }}
.stat.open .value {{ color:var(--blue); }}
.stat.independent .value {{ color:#7d5aa6; }}
.stats-title {{
  margin:28px 0 -12px;
  font:800 13px/1.2 ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
  letter-spacing:.08em;
  text-transform:uppercase;
  color:var(--muted);
}}
.graph-figure {{
  margin:18px 0 0;
  max-width:460px;
}}
.graph-figure img {{
  display:block;
  width:100%;
  height:auto;
  border:1px solid #28323a;
  background:#f7f9f4;
}}
.graph-figure figcaption {{
  margin-top:9px;
  color:var(--muted);
  font:13px/1.35 ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
}}
.legend {{
  display:flex;
  gap:12px;
  flex-wrap:wrap;
  margin-top:10px;
  color:var(--muted);
  font:13px/1.3 ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
}}
.legend span::before {{
  content:"";
  display:inline-block;
  width:10px;
  height:10px;
  margin-right:5px;
  border-radius:50%;
  background:var(--c);
}}
section {{
  display:grid;
  grid-template-columns:220px minmax(0, 1fr);
  gap:28px;
  padding:28px 0;
  border-top:1px solid var(--rule);
}}
h2 {{
  margin:0;
  font-size:22px;
  line-height:1.2;
}}
section p {{ margin:0 0 14px; max-width:78ch; }}
.tools {{
  list-style:none;
  margin:0;
  padding:0;
}}
.tools li {{
  padding:10px 0;
  border-top:1px solid var(--rule);
}}
.tools li:first-child {{ border-top:0; }}
.tools b {{
  display:inline-block;
  min-width:170px;
  font-family:ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
}}
.foot {{
  margin-top:34px;
  padding-top:18px;
  border-top:1px solid var(--rule);
  color:var(--muted);
  font:13px/1.5 ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
}}
@media (max-width:900px) {{
  .hero, section {{ grid-template-columns:1fr; }}
  .stats {{ grid-template-columns:repeat(2, minmax(0, 1fr)); }}
  h1 {{ font-size:38px; }}
}}
@media (max-width:620px) {{
  .page {{ width:min(100% - 24px, 1080px); padding-top:24px; }}
  h1 {{ font-size:34px; }}
  .subtitle {{ font-size:18px; }}
  .tools b {{ display:block; min-width:0; margin-bottom:3px; }}
}}
</style>
</head>
<body>
<main class="page">
  <header class="hero">
    <div>
      <p class="kicker">Lean 4 / Mathlib / topology</p>
      <h1>pibase-lean</h1>
      <p class="subtitle">Tracking Lean entries and proof debt for pi-Base topology.</p>
      <nav class="link-row" aria-label="Project links">
        <a href="blueprint.html">Blueprint</a>
        <a href="data.html">Data comparison</a>
        <a href="review.html">Review UI</a>
        <a href="{SOURCE_REPO}">GitHub</a>
        <a href="{PIBASE}/">pi-Base</a>
      </nav>
      <p class="lede">
        The main project status is the Lean work itself: how many pi-Base entries
        have corresponding Lean files, and how much visible proof debt remains in
        those files. Entry counts do not by themselves mean every definition and
        lemma is sorry-free. The implication outcome buckets are shown here too:
        true, false, axiom-dependent, and unclassified.
      </p>
    </div>
    <aside class="source-card">
      <h2>Source</h2>
      <p>{source_note}.</p>
      <p>Last source date: <code>{html.escape(formal["commit_date"])}</code></p>
      <p>This page is generated from a fresh checkout during the Pages workflow.</p>
    </aside>
  </header>

  <h2 class="stats-title">Formal Lean Data</h2>
  <div class="stats" aria-label="Lean formalization statistics">
    {lean_stats}
  </div>

  <h2 class="stats-title">Implication Outcomes</h2>
  <div class="stats" aria-label="Implication graph outcome statistics">
    {outcome_stats}
  </div>

  <section>
    <h2>Lean First</h2>
    <div>
      <p>
        These counts are taken from the Lean tree, not inferred from the informal
        pi-Base database. A property entry means a
        <code>PiBaseLean/Properties/P*</code> directory exists. A theorem entry
        means a <code>PiBaseLean/Theorems/T*</code> theorem folder exists.
      </p>
      <p>
        The property-layer sorry count scans property definition and lemma files.
        The theorem-file sorry count scans theorem files themselves. A theorem file
        can be sorry-free while depending on property-layer declarations that still
        contain <code>sorry</code>, so this is a progress view rather than a complete
        trust audit.
      </p>
    </div>
  </section>

  <section>
    <h2>Outcome Buckets</h2>
    <div>
      <p>
        The true/false/axiom-dependent/unclassified counts classify the full
        {comma(total)}-cell pi-Base implication graph. They are graph-status
        counts, not counts of completed Lean proofs.
      </p>
      <p>
        True splits into {comma(summary["explicitly_true"])} explicit pi-Base theorem
        edges and {comma(summary["implicitly_true"])} additional implications obtained
        by transitive closure. Axiom-dependent is reserved for pairs whose changing
        truth value is documented for named additional axioms.
      </p>
      <figure class="graph-figure">
        <img src="assets/implication-map.png" width="788" height="788" alt="The current 244 by 244 implication grid colored by true, false, axiom-dependent, unclassified, and diagonal cells.">
        <figcaption>Current 244-property implication grid generated from the pi-Base snapshot.</figcaption>
        <div class="legend" aria-label="Grid legend">
          <span style="--c:var(--green)">true</span>
          <span style="--c:var(--rust)">false</span>
          <span style="--c:#7d5aa6">axiom-dependent</span>
          <span style="--c:var(--blue)">unclassified</span>
        </div>
      </figure>
    </div>
  </section>

  <section>
    <h2>Pages</h2>
    <ul class="tools">
      <li><b><a href="blueprint.html">Blueprint</a></b> The web blueprint for the formalization plan.</li>
      <li><b><a href="data.html">Data comparison</a></b> How much of the current pi-Base snapshot is represented in Lean.</li>
      <li><b><a href="review.html">Review UI</a></b> Side-by-side pi-Base statements and Lean definitions.</li>
      <li><b><a href="{SOURCE_REPO}">GitHub</a></b> Felix Pernegger's pibase-lean repository.</li>
    </ul>
  </section>

  <footer class="foot">
    Formalization source: <a href="{SOURCE_REPO}">felixpernegger/pibase-lean</a>.
    Full pi-Base comparison data is generated from this site's pinned pi-Base snapshot.
  </footer>
</main>
</body>
</html>
"""


def build_data_page(data, coverage, questions, summary, formal, independence):
    counts = coverage["counts"]
    sha = data.get("version", {}).get("sha") or coverage.get("pin_sha", "")
    sha_short = sha[:12] if sha else "unknown"
    total = summary["total"]
    property_total = counts["properties"]
    theorem_total = counts["theorems"]
    property_covered = formal["property_entries"]
    theorem_covered = formal["theorem_entries"]
    property_missing = max(property_total - property_covered, 0)
    theorem_missing = max(theorem_total - theorem_covered, 0)
    coverage_rows = "\n".join([
        coverage_row(
            "pi-Base properties represented in Lean",
            property_covered,
            property_total,
            "A covered property has a PiBaseLean/Properties/P* entry in the Lean repository.",
            "properties",
        ),
        coverage_row(
            "pi-Base theorem rows represented in Lean",
            theorem_covered,
            theorem_total,
            "A covered theorem row has a PiBaseLean/Theorems/T* entry in the Lean repository.",
            "theorems",
        ),
    ])
    stats = "\n".join([
        stat_card(pct(property_covered, property_total), "property coverage",
                  f"{comma(property_covered)} of {comma(property_total)} pi-Base properties", "lean"),
        stat_card(pct(theorem_covered, theorem_total), "theorem-row coverage",
                  f"{comma(theorem_covered)} of {comma(theorem_total)} pi-Base theorem rows", "true"),
        stat_card(comma(property_missing), "property gaps",
                  "pi-Base property IDs without a P* entry", "open"),
        stat_card(comma(theorem_missing), "theorem-row gaps",
                  "pi-Base theorem rows without a T* entry", "missing"),
    ])

    return f"""<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>pibase-lean | Data comparison</title>
<meta name="description" content="Compare pibase-lean with the full pi-Base snapshot.">
<style>
:root {{
  --paper:#fbfcf8;
  --ink:#1d2328;
  --muted:#5d6670;
  --rule:#d8dfd3;
  --green:#257a57;
  --rust:#b85f4d;
  --blue:#315f95;
  --gold:#b98124;
  --purple:#7d5aa6;
  --panel:#ffffff;
  --code:#eef2ea;
}}
* {{ box-sizing:border-box; }}
html {{ scroll-behavior:smooth; }}
body {{
  margin:0;
  background:var(--paper);
  color:var(--ink);
  font:16px/1.58 ui-serif, Georgia, Cambria, "Times New Roman", serif;
}}
a {{ color:var(--blue); text-decoration-thickness:1px; text-underline-offset:3px; }}
a:hover {{ color:#1e426d; }}
.page {{
  width:min(1080px, calc(100% - 32px));
  margin:0 auto;
  padding:34px 0 56px;
}}
.hero {{
  display:grid;
  grid-template-columns:minmax(0, 1fr) minmax(300px, 34%);
  gap:32px;
  align-items:start;
  padding-bottom:28px;
  border-bottom:1px solid var(--rule);
}}
.kicker {{
  margin:0 0 10px;
  color:var(--muted);
  font:700 13px/1.2 ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
  letter-spacing:.08em;
  text-transform:uppercase;
}}
h1 {{
  margin:0;
  font-size:44px;
  line-height:1.02;
  letter-spacing:0;
  font-weight:700;
}}
.subtitle {{
  max-width:760px;
  margin:12px 0 18px;
  font-size:20px;
  line-height:1.45;
}}
.link-row {{
  display:flex;
  flex-wrap:wrap;
  gap:10px 18px;
  margin:20px 0 28px;
  font:600 15px/1.3 ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
}}
.link-row a {{ color:var(--ink); }}
.lede {{
  max-width:760px;
  margin:0;
}}
.source-card {{
  background:var(--panel);
  border:1px solid var(--rule);
  padding:16px;
  font:14px/1.45 ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
}}
.source-card h2 {{
  margin:0 0 10px;
  font:700 15px/1.2 ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
  text-transform:uppercase;
  letter-spacing:.06em;
}}
.source-card p {{ margin:0 0 10px; color:var(--muted); }}
.source-card code {{
  font-family:"SF Mono", Menlo, Consolas, monospace;
  color:var(--ink);
}}
.stats {{
  display:grid;
  grid-template-columns:repeat(4, minmax(0, 1fr));
  gap:1px;
  margin:28px 0;
  background:var(--rule);
  border:1px solid var(--rule);
}}
.stat {{
  min-height:118px;
  padding:16px 14px;
  background:var(--panel);
}}
.stat .value {{
  font:700 27px/1 ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
  letter-spacing:0;
}}
.stat .label {{
  margin-top:9px;
  font:700 13px/1.2 ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
  text-transform:uppercase;
  letter-spacing:.06em;
}}
.stat .note {{
  margin-top:7px;
  color:var(--muted);
  font:13px/1.35 ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
  overflow-wrap:anywhere;
}}
.stat.true .value {{ color:var(--green); }}
.stat.implicit .value {{ color:#52906c; }}
.stat.lean .value {{ color:var(--gold); }}
.stat.false .value {{ color:var(--rust); }}
.stat.open .value {{ color:var(--blue); }}
.stat.missing .value {{ color:var(--rust); }}
.stat.independent .value {{ color:var(--purple); }}
.stats-title {{
  margin:28px 0 -12px;
  font:800 13px/1.2 ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
  letter-spacing:.08em;
  text-transform:uppercase;
  color:var(--muted);
}}
.coverage-list {{
  display:grid;
  gap:18px;
}}
.coverage-row {{
  padding:0 0 16px;
  border-bottom:1px solid var(--rule);
}}
.coverage-row:last-child {{ border-bottom:0; padding-bottom:0; }}
.coverage-head {{
  display:flex;
  justify-content:space-between;
  gap:18px;
  margin-bottom:8px;
  font:15px/1.35 ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
}}
.coverage-head b {{ min-width:0; }}
.coverage-head span {{
  flex:0 0 auto;
  font-weight:700;
  color:var(--ink);
}}
.meter {{
  height:10px;
  background:#e7ece2;
  border:1px solid var(--rule);
}}
.meter i {{
  display:block;
  width:var(--w);
  height:100%;
  background:var(--gold);
}}
.coverage-row.theorems .meter i {{ background:var(--green); }}
.coverage-row p {{
  margin:8px 0 0;
  color:var(--muted);
  font:13px/1.4 ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
}}
table {{
  width:100%;
  table-layout:fixed;
  border-collapse:collapse;
  margin:2px 0 0;
  background:var(--panel);
  font:14px/1.45 ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
}}
th, td {{
  text-align:left;
  vertical-align:top;
  border:1px solid var(--rule);
  padding:9px 10px;
  overflow-wrap:anywhere;
}}
th {{ background:#eef2ea; }}
section {{
  display:grid;
  grid-template-columns:220px minmax(0, 1fr);
  gap:28px;
  padding:28px 0;
  border-top:1px solid var(--rule);
}}
section:first-of-type {{ border-top:0; }}
h2 {{
  margin:0;
  font-size:22px;
  line-height:1.2;
}}
section p {{
  margin:0 0 14px;
  max-width:78ch;
}}
.tools, .links, .questions, .witnesses {{
  list-style:none;
  margin:0;
  padding:0;
}}
.tools li, .links li {{
  padding:10px 0;
  border-top:1px solid var(--rule);
}}
.tools li:first-child, .links li:first-child {{ border-top:0; }}
.tools b, .links b {{
  display:inline-block;
  min-width:150px;
  font-family:ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
}}
pre {{
  margin:8px 0 0;
  padding:14px 16px;
  overflow:auto;
  background:var(--code);
  border:1px solid var(--rule);
  font:14px/1.5 "SF Mono", Menlo, Consolas, monospace;
}}
.foot {{
  margin-top:34px;
  padding-top:18px;
  border-top:1px solid var(--rule);
  color:var(--muted);
  font:13px/1.5 ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
}}
@media (max-width:900px) {{
  .hero, section {{ grid-template-columns:1fr; }}
  h1 {{ font-size:38px; }}
  .stats {{ grid-template-columns:repeat(2, minmax(0, 1fr)); }}
}}
@media (max-width:620px) {{
  .page {{ width:min(100% - 24px, 1080px); padding-top:24px; }}
  .hero {{ gap:20px; padding-bottom:22px; }}
  h1 {{ font-size:32px; }}
  .subtitle {{ font-size:18px; margin-bottom:14px; }}
  .link-row {{ gap:8px 14px; margin:16px 0 22px; font-size:14px; }}
  .stats {{ grid-template-columns:repeat(2, minmax(0, 1fr)); }}
  th, td {{ padding:7px 6px; font-size:12px; }}
  .tools b, .links b {{ display:block; min-width:0; margin-bottom:3px; }}
  .coverage-head {{ display:block; }}
  .coverage-head span {{ display:block; margin-top:4px; }}
}}
</style>
</head>
<body>
<main class="page">
  <header class="hero">
    <div>
      <p class="kicker">Lean 4 / Mathlib / topology</p>
      <h1>Data Comparison</h1>
      <p class="subtitle">How much of pi-Base has a corresponding entry in the Lean tree.</p>
      <nav class="link-row" aria-label="Project links">
        <a href="index.html">Home</a>
        <a href="blueprint.html">Blueprint</a>
        <a href="review.html">Review UI</a>
        <a href="{OPEN_APP}">Open implications</a>
        <a href="{PIBASE}/">pi-Base</a>
        <a href="{SOURCE_REPO}">GitHub</a>
      </nav>
      <p class="lede">
        This page treats coverage as representation: a pi-Base property or theorem
        row is covered when the repository has the matching <code>P*</code> or
        <code>T*</code> Lean entry. Coverage is not the same as being fully
        sorry-free, so proof debt is shown separately.
      </p>
    </div>
    <aside class="source-card">
      <h2>Sources</h2>
      <p>Lean entries: <a href="{formal["source_url"]}">{html.escape(formal["source_label"])}</a> at <code>{html.escape(formal["commit_short"])}</code>.</p>
      <p>pi-Base snapshot: <a href="https://github.com/pi-base/data/tree/{html.escape(sha)}"><code>{html.escape(sha_short)}</code></a>.</p>
      <p>The Pages workflow rebuilds the dashboard from this checkout on every deploy.</p>
    </aside>
  </header>

  <h2 class="stats-title">Entry Coverage</h2>
  <div class="stats" aria-label="Current project statistics">
    {stats}
  </div>

  <section>
    <h2>Coverage</h2>
    <div>
      <div class="coverage-list">
        {coverage_rows}
      </div>
    </div>
  </section>

  <section>
    <h2>Snapshot Table</h2>
    <div>
      <table>
        <tr><th>pi-Base object</th><th>pi-Base total</th><th>Lean entries</th><th>coverage</th><th>not yet represented</th></tr>
        <tr><td>properties</td><td>{comma(property_total)}</td><td>{comma(property_covered)}</td><td>{pct(property_covered, property_total)}</td><td>{comma(property_missing)}</td></tr>
        <tr><td>theorem rows</td><td>{comma(theorem_total)}</td><td>{comma(theorem_covered)}</td><td>{pct(theorem_covered, theorem_total)}</td><td>{comma(theorem_missing)}</td></tr>
      </table>
    </div>
  </section>

  <section>
    <h2>Proof Debt</h2>
    <div>
      <p>
        The property layer has {comma(formal["property_files"])} Lean files, with
        {comma(formal["property_sorries"])} visible <code>sorry</code> tokens across
        {comma(formal["property_files_with_sorry"])} files. This is why a property
        entry should be read as a represented pi-Base property, not automatically
        as a completed formalization.
      </p>
      <p>
        The theorem layer has {comma(formal["theorem_files"])} theorem files and
        {comma(formal["theorem_sorries"])} visible <code>sorry</code> tokens in
        <code>PiBaseLean/Theorems/T*/Theorem.lean</code>. A sorry-free theorem file
        may still depend on property-layer declarations that contain sorries.
      </p>
    </div>
  </section>

  <section>
    <h2>Graph Context</h2>
    <div>
      <p>
        The landing page shows the outcome buckets for the whole
        {comma(total)}-cell implication graph: {comma(summary["true"])} true,
        {comma(summary["false"])} false, {comma(summary["independent"])} dependent
        on named axioms, and {comma(summary["open"])} unclassified.
      </p>
      <p>
        There are {comma(independence["candidate_count"])} open set-theory candidates
        touching P000164, "Cardinality less than every measurable cardinal." They
        remain open until an independence proof is added to the certificate ledger.
      </p>
    </div>
  </section>

  <section>
    <h2>Tools</h2>
    <ul class="tools">
      <li><b><a href="index.html">Home</a></b> Lean-first formalization status.</li>
      <li><b><a href="review.html">Review UI</a></b> Side-by-side pi-Base statements and Lean definitions.</li>
      <li><b><a href="{OPEN_APP}">Open implications</a></b> Browser tool for testing and submitting unresolved implication claims.</li>
      <li><b><a href="{PIBASE}/">pi-Base</a></b> The source database of spaces, properties, theorems, and counterexamples.</li>
      <li><b><a href="{REPO_BLOB}/data/questions.json">Questions JSON</a></b> Machine-readable open implication frontier.</li>
    </ul>
  </section>

  <section>
    <h2>Building</h2>
    <div>
      <p>After installing Lean through elan and cloning the repository:</p>
      <pre><code>lake exe cache get
lake build
python3 scripts/gen_traits.py
python3 scripts/graph.py --witnesses
python3 scripts/build_review.py
python3 scripts/build_project_page.py</code></pre>
    </div>
  </section>

  <section>
    <h2>Links</h2>
    <ul class="links">
      <li><b><a href="{ETP}">Equational Theories</a></b> The project-page model and graph-completion inspiration.</li>
      <li><b><a href="{REPO_BLOB}/README.md">README</a></b> Repository overview, build commands, and design notes.</li>
      <li><b><a href="blueprint.html">Blueprint</a></b> Web blueprint for the Lean formalization and generated graph.</li>
      <li><b><a href="{SOURCE_REPO}">Repository</a></b> Felix Pernegger's pibase-lean project on GitHub.</li>
    </ul>
  </section>

  <footer class="foot">
    Generated from pi-Base data snapshot <a href="https://github.com/pi-base/data/tree/{html.escape(sha)}">{html.escape(sha_short)}</a>.
    Lean source commit: <a href="{formal["source_url"]}/commit/{html.escape(formal["commit"])}">{html.escape(formal["commit_short"])}</a>.
    pi-Base data is by Steven Clontz, James Dabbs, and the pi-Base community.
  </footer>
</main>
</body>
</html>
"""


def main():
    data = json.load(open(DATA))
    coverage = json.load(open(COVERAGE))
    questions = json.load(open(QUESTIONS))
    independence = independence_status(questions)
    summary = graph_status(
        data,
        independence["proven_pairs"],
        independence["conditional_space_ids"],
    )
    formal = formal_status(coverage)

    os.makedirs(ASSETS, exist_ok=True)
    write_graph_png(summary["rows"], GRAPH_PNG)
    with open(OUT, "w") as f:
        f.write(build_page(data, coverage, questions, summary, formal))
    with open(BLUEPRINT_OUT, "w") as f:
        f.write(build_blueprint_page(data, coverage, questions, summary))
    with open(DATA_OUT, "w") as f:
        f.write(build_data_page(data, coverage, questions, summary, formal, independence))

    print(f"wrote {OUT}")
    print(f"wrote {BLUEPRINT_OUT}")
    print(f"wrote {DATA_OUT}")
    print(f"wrote {GRAPH_PNG}")
    print(
        f"  {summary['true']} true, {summary['false']} false, "
        f"{summary['independent']} axiom-dependent, {summary['open']} unclassified "
        f"over {summary['total']} ordered pairs"
    )
    print(
        f"  {formal['property_entries']} Lean property entries, "
        f"{formal['theorem_entries']} Lean theorem entries "
        f"from {formal['source_label']}"
    )


if __name__ == "__main__":
    main()

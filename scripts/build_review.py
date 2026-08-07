#!/usr/bin/env python3
"""
build_review_pibase.py - human review UI over the pibase-lean formalization.
For each formalized property / theorem it shows the informal pi-Base statement
beside the Lean definition/proof from this checkout, so a human can check
faithfulness at a glance. Reuses the WikiLean review aesthetic.

Reads:  the pi-base data blob (informal statements) + this Lean checkout.
Writes: site/review.html
"""
import html
import json
import os
import re
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
FELIX = os.environ.get("PIBASE_LEAN_SOURCE", os.path.dirname(HERE))  # repo root (scripts/..)
PIBASE_DATA = os.path.join(FELIX, "data", "pibase.json")
OUT = os.path.join(FELIX, "site", "review.html")
PIBASE = "https://topology.pi-base.org"
SOURCE_REF = (
    os.environ.get("PIBASE_LEAN_SOURCE_REF")
    or subprocess.run(["git", "-C", FELIX, "rev-parse", "HEAD"],
                      capture_output=True, text=True).stdout.strip()
    or "master"
)
GH = f"https://github.com/felixpernegger/pibase-lean/blob/{SOURCE_REF}"

# ---------- per-file authorship (who wrote this Lean file) ----------
# Fold aliases so one person reads as one name. Several of Felix's commits are
# authored as "Batixx"/"felixpernegger" but share his uni-bonn email; our spaces
# are Jack's. Everyone else (other theorem contributors) shows their own name.
ME_EMAIL = "jack.mccarthy.1@stonybrook.edu"
AUTHOR_ALIASES = {                       # email -> canonical display name
    ME_EMAIL: "Jack McCarthy",
    "s59fpern@uni-bonn.de": "Felix Pernegger",
}
AUTHORS = {}                             # repo-relative path -> (display_name, is_me)


def load_authors(root):
    """Attribute each Lean file to the author of the commit that ADDED it. These
    files are effectively write-once (each space/property/theorem lands in one
    commit and is rarely touched again), so added-by == author. One git pass;
    returns {} on any failure — e.g. a shallow CI checkout with no history — so
    the badges simply degrade to absent rather than breaking the build."""
    try:
        out = subprocess.run(
            ["git", "-C", root, "log", "--reverse", "--no-renames",
             "--diff-filter=A", "--format=%x00%an%x09%ae", "--name-only",
             "--", "PiBaseLean"],
            capture_output=True, text=True, check=True).stdout
    except Exception:
        return
    name = email = None
    for ln in out.splitlines():
        if ln.startswith("\x00"):                     # commit header line
            name, email = (ln[1:].split("\t", 1) + [""])[:2]
        elif ln.strip() and ln not in AUTHORS:        # file added here (oldest wins)
            disp = AUTHOR_ALIASES.get(email, name)
            AUTHORS[ln] = (disp, email == ME_EMAIL)


def author_badge(rel):
    a = AUTHORS.get(rel)
    if not a:
        return ""
    disp, me = a
    return (f'<span class="auth{" me" if me else ""}" title="authored by {html.escape(disp)}">'
            f'<span class="pen">✍</span>{html.escape(disp)}</span>')


# ---------- Lean syntax highlighting (VS Code Light+ token classes) ----------
KEYWORDS = {
    "import", "module", "public", "open", "namespace", "end", "section",
    "variable", "abbrev", "def", "theorem", "lemma", "instance", "example",
    "structure", "class", "where", "fun", "by", "do", "let", "have", "show",
    "from", "intro", "intros", "exact", "refine", "apply", "rw", "simp",
    "rcases", "obtain", "constructor", "cases", "induction", "at", "with",
    "deriving", "opaque", "attribute", "convert", "refine'", "sorry",
}


def lean_html(code):
    out, i, n = [], 0, len(code)
    esc = html.escape
    while i < n:
        if code[i:i + 2] == "/-":
            # consume a whole (possibly nested) block comment in one shot
            j, d = i + 2, 1
            while j < n and d > 0:
                if code[j:j + 2] == "/-":
                    d += 1; j += 2
                elif code[j:j + 2] == "-/":
                    d -= 1; j += 2
                else:
                    j += 1
            out.append(f'<span class="c1">{esc(code[i:j])}</span>'); i = j; continue
        if code[i:i + 2] == "--":
            j = code.find("\n", i)
            j = n if j == -1 else j
            out.append(f'<span class="c1">{esc(code[i:j])}</span>'); i = j; continue
        if code[i] == '"':
            j = i + 1
            while j < n and code[j] != '"':
                j += 1
            out.append(f'<span class="s">{esc(code[i:j + 1])}</span>'); i = j + 1; continue
        m = re.match(r"[A-Za-z_][A-Za-z0-9_\.\'ₙ]*", code[i:])
        if m:
            w = m.group(0)
            cls = "kn" if w in KEYWORDS else ("kt" if w[0].isupper() else "nf")
            out.append(f'<span class="{cls}">{esc(w)}</span>'); i += len(w); continue
        if code[i].isdigit():
            m = re.match(r"\d+", code[i:])
            if m:
                out.append(f'<span class="mi">{esc(m.group(0))}</span>')
                i += len(m.group(0)); continue
        out.append(esc(code[i])); i += 1
    return "".join(out)


# ---------- pi-base macro substitution in informal text ----------
def clean_informal(text, pname, sname):
    if not text:
        return ""
    text = text.split("----")[0].strip()  # drop the meta-properties tail
    text = re.sub(r"\{\{[^}]*\}\}", "[ref]", text)
    text = re.sub(r"\{S0*(\d+)\|P0*\d+\}",
                  lambda m: f"[{sname.get('S'+m.group(1).zfill(6), 'S'+m.group(1))}]({PIBASE}/spaces/S{m.group(1).zfill(6)})", text)
    text = re.sub(r"\{P0*(\d+)\}",
                  lambda m: f"[{pname.get('P'+m.group(1).zfill(6), 'P'+m.group(1))}]({PIBASE}/properties/P{m.group(1).zfill(6)})", text)
    text = re.sub(r"\{S0*(\d+)\}",
                  lambda m: f"[{sname.get('S'+m.group(1).zfill(6), 'S'+m.group(1))}]({PIBASE}/spaces/S{m.group(1).zfill(6)})", text)
    return text.strip()


def render_statement(formula, pname):
    """Render a pi-base when/then formula as linked, math-y markdown."""
    k = formula["kind"]
    if k == "atom":
        uid = formula["property"]
        nm = pname.get(uid, uid)
        lit = f'<a class="plink" data-p="P{int(uid[1:])}">{nm}</a>'
        return lit if formula["value"] else f"¬ {lit}"
    sep = " ∧ " if k == "and" else " ∨ "
    return sep.join(render_statement(s, pname) for s in formula["subs"])


def read_lean(path):
    """Read a Lean file, stripping module/import/expose boilerplate so the card
    focuses on the actual definition or proof."""
    if not os.path.exists(path):
        return None
    lines = open(path).read().splitlines()
    out, i = [], 0
    boiler = re.compile(r"^\s*(module\b|public\s+import\b|import\b|@\[expose\]\s*public\s+section\b)")
    for ln in lines:
        if boiler.match(ln):
            continue
        out.append(ln)
    text = "\n".join(out)
    text = re.sub(r"\n{3,}", "\n\n", text).strip("\n")
    return text


def main():
    load_authors(FELIX)
    data = json.load(open(PIBASE_DATA))
    P = {p["uid"]: p for p in data["properties"]}
    T = {t["uid"]: t for t in data["theorems"]}
    pname = {p["uid"]: p["name"] for p in data["properties"]}
    sname = {s["uid"]: s["name"] for s in data["spaces"]}

    propdir = os.path.join(FELIX, "PiBaseLean", "Properties")
    thmdir = os.path.join(FELIX, "PiBaseLean", "Theorems")

    # ----- property cards -----
    pids = sorted((int(d[1:]) for d in os.listdir(propdir)
                   if re.fullmatch(r"P\d+", d)))
    pcards = []
    for n in pids:
        uid = f"P{n:06d}"
        p = P.get(uid, {})
        nm = p.get("name", f"P{n}")
        desc = clean_informal(p.get("description", ""), pname, sname)
        d = os.path.join(propdir, f"P{n}")
        defs = read_lean(os.path.join(d, "Defs.lean"))
        lemmas = read_lean(os.path.join(d, "Lemmas.lean"))
        lean = defs or "-- (no Defs.lean)"
        extra = (f'<details class="more"><summary>+ Lemmas.lean</summary>'
                 f'<pre class="lean">{lean_html(lemmas)}</pre></details>' if lemmas else "")
        rel = f"PiBaseLean/Properties/P{n}/Defs.lean"
        aname = AUTHORS.get(rel, ("", False))[0]
        pcards.append(f'''<div class="entry" data-kind="prop" id="c-prop-P{n}"
  data-search="{html.escape((uid + ' P' + str(n) + ' ' + nm + ' ' + aname).lower())}">
  <header>
    <span class="uid"><a href="{PIBASE}/properties/{uid}" target="_blank" rel="noopener">P{n}</a></span>
    <span class="name" data-math>{html.escape(nm)}</span>
    {author_badge(rel)}
    <a class="gh" href="{GH}/PiBaseLean/Properties/P{n}/Defs.lean" target="_blank" rel="noopener">source ↗</a>
    <span class="rev-controls"></span>
  </header>
  <div class="panes">
    <div class="informal">
      <div class="md" data-md>{html.escape(desc) if desc else '<span class="empty">No informal description.</span>'}</div>
      <p class="src-link"><a href="{PIBASE}/properties/{uid}" target="_blank" rel="noopener">View on π-Base ↗</a></p>
    </div>
    <div class="lean-pane"><pre class="lean">{lean_html(lean)}</pre>{extra}</div>
  </div>
</div>''')

    # ----- theorem cards -----
    tids = sorted((int(d[1:]) for d in os.listdir(thmdir)
                   if re.fullmatch(r"T\d+", d)))
    tcards = []
    for n in tids:
        uid = f"T{n:06d}"
        t = T.get(uid)
        stmt = (render_statement(t["when"], pname) + " &nbsp;⟹&nbsp; "
                + render_statement(t["then"], pname)) if t else "(statement unavailable)"
        just = clean_informal((t or {}).get("description", ""), pname, sname)
        d = os.path.join(thmdir, f"T{n}")
        thm = read_lean(os.path.join(d, "Theorem.lean")) or "-- (no Theorem.lean)"
        lemmas = read_lean(os.path.join(d, "Lemmas.lean"))
        extra = (f'<details class="more"><summary>+ Lemmas.lean</summary>'
                 f'<pre class="lean">{lean_html(lemmas)}</pre></details>' if lemmas else "")
        just_banner = (f'<div class="thm-just" data-md>{html.escape(just)}</div>'
                       if just else "")
        rel = f"PiBaseLean/Theorems/T{n}/Theorem.lean"
        aname = AUTHORS.get(rel, ("", False))[0]
        tcards.append(f'''<div class="entry thm" data-kind="thm" id="c-thm-T{n}"
  data-search="{html.escape(('t'+str(n)+' '+re.sub(r'<[^>]+>','',stmt).lower()+' '+aname.lower()))}">
  <header>
    <span class="uid"><a href="{PIBASE}/theorems/{uid}" target="_blank" rel="noopener">T{n}</a></span>
    <span class="name" data-math>{stmt}</span>
    {author_badge(rel)}
    <a class="gh" href="{PIBASE}/theorems/{uid}" target="_blank" rel="noopener">π-Base ↗</a>
    <a class="gh" href="{GH}/PiBaseLean/Theorems/T{n}/Theorem.lean" target="_blank" rel="noopener">source ↗</a>
    <span class="rev-controls"></span>
  </header>
  {just_banner}
  <div class="lean-pane"><pre class="lean">{lean_html(thm)}</pre>{extra}</div>
</div>''')

    # ----- space cards -----
    S = {s["uid"]: s for s in data["spaces"]}
    tpath = os.path.join(FELIX, "data", "traits.json")
    traits = json.load(open(tpath)) if os.path.exists(tpath) else {}
    spdir = os.path.join(FELIX, "PiBaseLean", "Spaces")
    sids = sorted(int(d[1:]) for d in os.listdir(spdir)
                  if re.fullmatch(r"S\d+", d)
                  and os.path.exists(os.path.join(spdir, d, "Defs.lean")))
    scards = []
    TRAITS = {}          # S<n> -> [[value, propNum, name, status], ...]  (built lazily in JS)
    for n in sids:
        uid = f"S{n:06d}"
        s = S.get(uid, {})
        nm = s.get("name", f"S{n}")
        desc = clean_informal(s.get("description", ""), pname, sname)
        lean = read_lean(os.path.join(spdir, f"S{n}", "Defs.lean")) or "-- (no Defs.lean)"
        rows = traits.get(uid, {}).get("traits", [])
        cnt = {"proven": 0, "asserted": 0, "derivable": 0}
        for r in rows:
            cnt[r["status"]] = cnt.get(r["status"], 0) + 1
        TRAITS[f"S{n}"] = [[1 if r["value"] else 0, int(r["property"][1:]),
                            r["name"], r["status"][0]] for r in rows]   # status→first letter
        tsummary = (f'{len(rows)} traits · <b>{cnt["proven"]}</b> proven · '
                    f'{cnt["asserted"]} asserted · {cnt["derivable"]} derivable') if rows else "no trait data"
        traits_block = (f'<details class="traits" data-space="S{n}"><summary>{tsummary}</summary>'
                        f'<div class="trwrap"></div></details>') if rows else ""
        rel = f"PiBaseLean/Spaces/S{n}/Defs.lean"
        aname = AUTHORS.get(rel, ("", False))[0]
        scards.append(f'''<div class="entry" data-kind="space" id="c-space-S{n}"
  data-search="{html.escape((uid + ' S' + str(n) + ' ' + nm + ' ' + aname).lower())}">
  <header>
    <span class="uid"><a href="{PIBASE}/spaces/{uid}" target="_blank" rel="noopener">S{n}</a></span>
    <span class="name" data-math>{html.escape(nm)}</span>
    {author_badge(rel)}
    <a class="gh" href="{PIBASE}/spaces/{uid}" target="_blank" rel="noopener">π-Base ↗</a>
    <a class="gh" href="{GH}/PiBaseLean/Spaces/S{n}/Defs.lean" target="_blank" rel="noopener">source ↗</a>
    <span class="rev-controls"></span>
  </header>
  <div class="panes">
    <div class="informal">
      <div class="md" data-md>{html.escape(desc) if desc else '<span class="empty">No informal description.</span>'}</div>
      <p class="src-link"><a href="{PIBASE}/spaces/{uid}" target="_blank" rel="noopener">View on π-Base ↗</a></p>
    </div>
    <div class="lean-pane"><pre class="lean">{lean_html(lean)}</pre></div>
  </div>
  {traits_block}
</div>''')

    page = TEMPLATE.format(
        n_props=len(pcards), n_thms=len(tcards), n_spaces=len(scards),
        prop_cards="\n".join(pcards), thm_cards="\n".join(tcards),
        space_cards="\n".join(scards),
        traits_json=json.dumps(TRAITS, ensure_ascii=False, separators=(",", ":")))
    page = page.replace("<!--MAINJS-->", MAINJS)
    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    open(OUT, "w").write(page)
    print(f"wrote {OUT}: {len(pcards)} properties, {len(scards)} spaces, {len(tcards)} theorems")


TEMPLATE = r'''<!doctype html>
<html lang="en"><head>
<meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>π-Base Lean — review</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">
<script defer src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js"></script>
<script defer src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/contrib/auto-render.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/marked/marked.min.js"></script>
<style>
:root{{--bg:#faf7f1;--card:#fffdf9;--rule:#e3dccb;--ink:#1f1d1a;--muted:#6b6457;--accent:#7a3d2a;
 --code:#f3efe6;--g:#2d7a4a;--r:#a02828;--gb:#e8f4ec;}}
*{{box-sizing:border-box}}
body{{font:15px/1.55 -apple-system,BlinkMacSystemFont,"Segoe UI",system-ui,sans-serif;color:var(--ink);
 background:var(--bg);margin:0 auto;max-width:1180px;padding:1.5rem 1rem 5rem}}
h1{{font-size:1.5rem;margin:0 0 .25rem}}
.lede{{color:var(--muted);margin:0 0 1rem;max-width:75ch}} .lede a{{color:var(--accent)}}
#controls{{position:sticky;top:0;z-index:5;background:var(--bg);padding:.7rem 0;margin:0 0 1rem;
 display:flex;gap:.6rem;align-items:center;flex-wrap:wrap;border-bottom:1px solid var(--rule)}}
#controls input{{font:inherit;padding:.4rem .6rem;border:1px solid var(--rule);border-radius:6px;background:#fff;min-width:250px}}
.seg{{display:inline-flex;border:1px solid var(--rule);border-radius:6px;overflow:hidden}}
.seg button{{font:inherit;font-size:.88rem;padding:.4rem .8rem;border:0;background:#fff;color:var(--ink);cursor:pointer}}
.seg button.on{{background:var(--accent);color:#fff}}
.count{{font-size:.85rem;color:var(--muted);margin-left:auto}}
.sec-title{{font-size:1.05rem;margin:1.4rem 0 .6rem;color:var(--accent);font-weight:600}}
.entry{{background:var(--card);border:1px solid var(--rule);border-left:5px solid var(--rule);
 border-radius:7px;margin:.8rem 0;overflow:hidden}}
.entry[data-rev=ok]{{border-left-color:var(--g)}} .entry[data-rev=flag]{{border-left-color:var(--r)}}
.entry header{{display:flex;gap:.55rem;align-items:baseline;flex-wrap:wrap;padding:.55rem .9rem;
 background:#f6f2e9;border-bottom:1px solid var(--rule)}}
.entry header .uid a{{font-family:"JuliaMono","SF Mono",Menlo,monospace;color:var(--accent);text-decoration:none;font-size:.82rem}}
.entry header .name{{font-weight:600}}
a.gh{{color:var(--accent);text-decoration:none;font-size:.76rem;border:1px solid #e0c8ba;border-radius:5px;padding:.03rem .4rem;margin-left:.2rem}}
a.gh:hover{{background:#fbf6ec}}
.auth{{font-size:.72rem;color:var(--muted);display:inline-flex;align-items:center;gap:.22rem;white-space:nowrap;
 border:1px solid var(--rule);border-radius:20px;padding:.03rem .5rem;background:#fbf9f3}}
.auth.me{{color:var(--accent);border-color:#e0c8ba;background:#fbf3ec}}
.auth .pen{{opacity:.65;font-size:.85em}}
.rev-controls{{margin-left:auto;display:flex;gap:.3rem}}
.rev-controls button{{font:inherit;font-size:.78rem;padding:.15rem .5rem;border:1px solid var(--rule);background:#fff;border-radius:5px;cursor:pointer;color:var(--muted)}}
.rev-controls button.on[data-v=ok]{{background:var(--gb);color:var(--g);border-color:#bfe0cb}}
.rev-controls button.on[data-v=flag]{{background:#fbe8e8;color:var(--r);border-color:#e6b8b8}}
.panes{{display:grid;grid-template-columns:1fr 1fr}}
.informal{{padding:.75rem .9rem;border-right:1px solid var(--rule);background:#fdfcf8}}
.informal .md{{font-size:.92rem;line-height:1.5}} .informal .md p{{margin:.2rem 0 .6rem}}
.informal .md a,.name a{{color:var(--accent)}} .informal .empty{{color:var(--muted);font-style:italic}}
.src-link{{font-size:.82rem;margin:.5rem 0 0}} .src-link a{{color:var(--accent);text-decoration:none}}
.lean-pane{{overflow:auto}}
/* code blocks: dark mode with standard Lean (VS Code Dark+) syntax colors */
pre.lean{{font-family:"JuliaMono","JetBrains Mono","SF Mono",Menlo,Consolas,monospace;font-size:.79rem;
 background:#1e1e1e;color:#d4d4d4;margin:0;padding:.7rem .9rem;overflow:auto;white-space:pre-wrap;line-height:1.5}}
details.more summary{{cursor:pointer;font-size:.78rem;color:var(--accent);padding:.35rem .9rem;background:#f6f2e9;border-top:1px solid var(--rule)}}
.entry.thm .thm-just{{font-size:.88rem;line-height:1.5;padding:.55rem .9rem;background:#fbf6ec;border-bottom:1px solid var(--rule);color:#3a2a20;font-style:italic}}
.entry.thm .thm-just p{{margin:.15rem 0}} .entry.thm .thm-just a{{color:var(--accent);font-style:normal}}
.entry.thm .lean-pane{{border-top:none}} .entry.thm header .name{{font-weight:600}}
pre.lean .c1{{color:#6a9955;font-style:italic}} pre.lean .kn{{color:#569cd6}} pre.lean .kt{{color:#4ec9b0}}
pre.lean .nf{{color:#d4d4d4}} pre.lean .s{{color:#ce9178}} pre.lean .mi{{color:#b5cea8}}
/* trait table (spaces) */
details.traits summary{{cursor:pointer;font-size:.82rem;color:var(--muted);padding:.45rem .9rem;background:#f6f2e9;border-top:1px solid var(--rule)}}
details.traits summary b{{color:var(--g)}}
table.trtab{{width:100%;border-collapse:collapse;font-size:.86rem;background:#fdfcf8}}
table.trtab td{{padding:.2rem .5rem;border-top:1px solid #efe9dc;vertical-align:middle}}
table.trtab td:first-child{{width:1.4rem;text-align:center}}
table.trtab td:last-child{{width:6rem;text-align:right}}
table.trtab a{{color:var(--ink);text-decoration:none}} table.trtab a:hover{{color:var(--accent)}}
.yes{{color:var(--g);font-weight:700}} .no{{color:var(--r);font-weight:700}}
.stbadge{{font-size:.68rem;padding:.03rem .4rem;border-radius:10px;border:1px solid var(--rule)}}
.st-g{{color:var(--g);background:var(--gb);border-color:#bfe0cb}}
.st-a{{color:var(--y);background:#fbf3e0;border-color:#e8d5a8}}
.st-b{{color:#2b6cb0;background:#e8f0fb;border-color:#b8d0ec}}
:root{{--y:#b77a14}}
#controls .row{{display:flex;gap:.6rem;align-items:center;flex-wrap:wrap}}
#controls .row.trfilt{{margin-top:.5rem}}
#controls .lbl{{color:var(--muted);font-size:.82rem}}
#btn-next,#btn-flagged{{font:inherit;font-size:.84rem;padding:.35rem .7rem;border:1px solid var(--accent);background:#fff;color:var(--accent);border-radius:6px;cursor:pointer}}
#btn-next:hover,#btn-flagged:hover{{background:#fbf6ec}}
label.chk{{font-size:.85rem;color:var(--muted);display:inline-flex;gap:.3rem;align-items:center;cursor:pointer}}
.chip{{font:inherit;font-size:.78rem;padding:.2rem .55rem;border:1px solid var(--rule);background:#fff;color:var(--muted);border-radius:20px;cursor:pointer}}
.chip.on{{background:var(--accent);color:#fff;border-color:var(--accent)}}
.plink{{color:var(--accent);cursor:pointer;text-decoration:none;border-bottom:1px dotted #d0b8a8}}
.plink:hover{{background:#fbf6ec}}
.entry.focused{{box-shadow:0 0 0 2px var(--accent)}}
.entry.flash{{animation:flash 1.2s ease}}
@keyframes flash{{0%{{background:#fbefd6}}100%{{background:var(--card)}}}}
#flagpanel{{position:fixed;top:0;right:0;bottom:0;width:340px;max-width:90vw;background:var(--card);
 border-left:1px solid var(--rule);box-shadow:-4px 0 16px rgba(0,0,0,.08);z-index:20;overflow:auto}}
.fp-head{{display:flex;gap:.5rem;align-items:center;padding:.7rem .9rem;border-bottom:1px solid var(--rule);position:sticky;top:0;background:var(--card)}}
.fp-head b{{margin-right:auto}}
.fp-head button{{font:inherit;font-size:.8rem;padding:.2rem .5rem;border:1px solid var(--rule);background:#fff;border-radius:5px;cursor:pointer;color:var(--accent)}}
.fp-item{{padding:.4rem .9rem;border-bottom:1px solid #efe9dc;font-size:.88rem;cursor:pointer}}
.fp-item:hover{{background:#fbf6ec}} .fp-id{{font-family:"JuliaMono","SF Mono",Menlo,monospace;color:var(--accent);font-size:.8rem}}
#fp-list .empty{{padding:1rem;color:var(--muted);font-style:italic}}
#hint{{position:fixed;bottom:.7rem;left:50%;transform:translateX(-50%);display:flex;gap:.85rem;
 align-items:center;background:#2f2a24;color:#efe7d6;font-size:.78rem;padding:.4rem .95rem;
 border-radius:22px;z-index:15;box-shadow:0 3px 12px rgba(0,0,0,.22)}}
#hint .hl{{font-weight:600;color:#f3d9b0}}
#hint span{{white-space:nowrap}}
#hint kbd{{background:#efe7d6;color:#2f2a24;font-family:"JuliaMono","SF Mono",Menlo,monospace;font-size:.72rem;
 padding:.05rem .35rem;border-radius:4px;margin-right:.12rem;box-shadow:0 1px 0 #b0a68f}}
#hint-x{{background:none;border:none;color:#bcb29a;cursor:pointer;font-size:.8rem;padding:0 0 0 .2rem}}
#hint-x:hover{{color:#efe7d6}}
#hint-show{{position:fixed;bottom:.7rem;left:.7rem;background:#2f2a24;color:#efe7d6;border:none;
 border-radius:50%;width:2.1rem;height:2.1rem;cursor:pointer;z-index:15;font-size:1rem;box-shadow:0 2px 8px rgba(0,0,0,.2)}}
@media (max-width:820px){{#hint{{flex-wrap:wrap;max-width:94vw;justify-content:center;gap:.5rem .85rem}}}}
@media (max-width:820px){{.panes{{grid-template-columns:1fr}}.informal{{border-right:none;border-bottom:1px solid var(--rule)}}}}
.hidden{{display:none}}
</style></head><body>
<h1>π-Base Lean — review</h1>
<p class="lede">The <a href="https://github.com/felixpernegger/pibase-lean" target="_blank" rel="noopener">felixpernegger/pibase-lean</a>
formalization, presented for human review. Each card shows the informal
<a href="https://topology.pi-base.org" target="_blank" rel="noopener">π-Base</a> statement beside the Lean
definition/proof. Review marks are saved in your browser.</p>
<div id="controls">
 <div class="row">
  <input id="q" type="search" placeholder="filter  ( / )" autocomplete="off">
  <span class="seg" id="seg">
    <button data-f="spaces" class="on">Spaces ({n_spaces})</button>
    <button data-f="props">Properties ({n_props})</button>
    <button data-f="thms">Theorems ({n_thms})</button>
  </span>
  <button id="btn-next" title="jump to next unreviewed (n)">⏭ next unreviewed</button>
  <label class="chk"><input type="checkbox" id="hideRev"> hide reviewed</label>
  <button id="btn-flagged">⚑ Flagged <span id="flagN">0</span></button>
  <span class="count" id="count"></span>
 </div>
 <div class="row trfilt" id="trfilt">
  <span class="lbl">Traits:</span>
  <button class="chip on" data-tf="y">✓ holds</button>
  <button class="chip on" data-tf="n">✗ fails</button>
  <span class="lbl">·</span>
  <button class="chip on" data-tf="p">proven</button>
  <button class="chip on" data-tf="a">asserted</button>
  <button class="chip on" data-tf="d">derivable</button>
 </div>
</div>
<div id="flagpanel" class="hidden"><div class="fp-inner">
  <div class="fp-head"><b>Flagged for review</b>
    <button id="fp-copy">copy list</button><button id="fp-close">✕</button></div>
  <div id="fp-list"></div>
</div></div>
<div class="hint" id="hint">
  <span class="hl">⌨ shortcuts</span>
  <span><kbd>j</kbd><kbd>k</kbd> move</span><span><kbd>o</kbd> ok</span><span><kbd>f</kbd> flag</span>
  <span><kbd>n</kbd> next unreviewed</span><span><kbd>/</kbd> filter</span><span><kbd>?</kbd> toggle</span>
  <button id="hint-x" title="hide (?)">✕</button>
</div>
<button id="hint-show" class="hidden" title="keyboard shortcuts (?)">⌨</button>
<div id="sec-spaces"><div class="sec-title">Spaces — {n_spaces} formalized (carrier + topology; trait tables from the deduction closure)</div>{space_cards}</div>
<div id="sec-props" class="hidden"><div class="sec-title">Properties — {n_props} formalized</div>{prop_cards}</div>
<div id="sec-thms" class="hidden"><div class="sec-title">Theorems — {n_thms} represented (see the project dashboard for dependency-aware trust status)</div>{thm_cards}</div>
<script id="traitdata" type="application/json">{traits_json}</script>
<!--MAINJS-->
</body></html>'''


MAINJS = r'''<script>
const TRAITS=JSON.parse(document.getElementById('traitdata').textContent);
const STATN={p:['proven','st-g'],a:['asserted','st-a'],d:['derivable','st-b']};
const KEY='pbl-felix-review';
let marks=JSON.parse(localStorage.getItem(KEY)||'{}');
const $=s=>document.querySelector(s),$$=s=>[...document.querySelectorAll(s)];
const secOf={space:'spaces',prop:'props',thm:'thms'},SEC={spaces:'sec-spaces',props:'sec-props',thms:'sec-thms'};
const q=$('#q');
function idOf(e){return e.dataset.kind+e.querySelector('.uid a').textContent;}
function applyMark(e){const v=marks[idOf(e)];if(v)e.dataset.rev=v;else delete e.dataset.rev;
 e.querySelectorAll('.rev-controls button').forEach(b=>b.classList.toggle('on',b.dataset.v===v));}
function setMark(e,v){const id=idOf(e);marks[id]=(marks[id]===v)?undefined:v;if(!marks[id])delete marks[id];
 localStorage.setItem(KEY,JSON.stringify(marks));applyMark(e);refreshFlag();update();}
$$('.entry').forEach(e=>{const rc=e.querySelector('.rev-controls');
 rc.innerHTML='<button data-v="ok">✓ ok</button><button data-v="flag">⚑ flag</button>';
 rc.querySelectorAll('button').forEach(b=>b.onclick=ev=>{ev.stopPropagation();setMark(e,b.dataset.v);});applyMark(e);});

// lazy per-section render (markdown + KaTeX)
const rendered=new Set();
function typesetEl(el){if(window.renderMathInElement)try{renderMathInElement(el,{delimiters:[{left:'$$',right:'$$',display:true},{left:'$',right:'$',display:false}],throwOnError:false});}catch(e){}}
function renderSection(kind){if(rendered.has(kind))return;rendered.add(kind);const sec=$('#'+SEC[kind]);
 sec.querySelectorAll('[data-md]').forEach(el=>{try{el.innerHTML=marked.parse(el.textContent);}catch(e){}});typesetEl(sec);}

// lazy trait tables + filters
const TF={y:1,n:1,p:1,a:1,d:1};
function buildTraits(det){const rows=TRAITS[det.dataset.space]||[],wrap=det.querySelector('.trwrap');
 if(wrap.dataset.built)return;wrap.dataset.built='1';
 const tb=rows.map(r=>{const v=r[0],pn=r[1],nm=r[2],st=r[3],S=STATN[st];
  return '<tr data-v="'+(v?'y':'n')+'" data-s="'+st+'"><td>'+(v?'<span class=yes>✓</span>':'<span class=no>✗</span>')
   +'</td><td><a class="plink" data-p="P'+pn+'">'+nm+'</a></td><td><span class="stbadge '+S[1]+'">'+S[0]+'</span></td></tr>';}).join('');
 wrap.innerHTML='<table class="trtab"><tbody>'+tb+'</tbody></table>';typesetEl(wrap);filterTraits(wrap);}
function filterTraits(scope){(scope||document).querySelectorAll('table.trtab tr').forEach(tr=>{
  tr.style.display=(TF[tr.dataset.v]&&TF[tr.dataset.s[0]])?'':'none';});}
$$('details.traits').forEach(d=>d.addEventListener('toggle',()=>{if(d.open)buildTraits(d);}));
$$('#trfilt .chip').forEach(c=>c.onclick=()=>{c.classList.toggle('on');TF[c.dataset.tf]=c.classList.contains('on')?1:0;filterTraits();});

// cross-linking (property references jump to the property card)
function jumpTo(kind,uid){setFilter(secOf[kind]);q.value='';$('#hideRev').checked=false;update();
 const el=$('#c-'+kind+'-'+uid);if(!el)return;el.classList.remove('hidden');el.scrollIntoView({block:'center'});
 el.classList.add('flash');setTimeout(()=>el.classList.remove('flash'),1200);}
document.addEventListener('click',ev=>{const a=ev.target.closest('.plink');if(a){ev.preventDefault();jumpTo('prop',a.dataset.p);}});

// flagged panel
function flaggedList(){return Object.keys(marks).filter(id=>marks[id]==='flag');}
function refreshFlag(){$('#flagN').textContent=flaggedList().length;}
function nameFor(id){const el=$$('.entry').find(e=>idOf(e)===id);return el?el.querySelector('.name').textContent.trim():id;}
$('#btn-flagged').onclick=()=>{const list=flaggedList();
 $('#fp-list').innerHTML=list.length?list.map(id=>{const m=id.match(/^(space|prop|thm)(.+)$/);
  return '<div class="fp-item" data-k="'+m[1]+'" data-u="'+m[2]+'"><span class="fp-id">'+m[2]+'</span> '+nameFor(id)+'</div>';}).join('')
  :'<div class="empty">nothing flagged yet</div>';$('#flagpanel').classList.toggle('hidden');};
$('#fp-close').onclick=()=>$('#flagpanel').classList.add('hidden');
$('#fp-copy').onclick=()=>{const t=flaggedList().map(id=>{const m=id.match(/^(space|prop|thm)(.+)$/);return '- '+m[2]+' '+nameFor(id);}).join('\n');
 navigator.clipboard.writeText(t);$('#fp-copy').textContent='copied';setTimeout(()=>$('#fp-copy').textContent='copy list',1200);};
$('#fp-list').onclick=ev=>{const it=ev.target.closest('.fp-item');if(it){$('#flagpanel').classList.add('hidden');jumpTo(it.dataset.k,it.dataset.u);}};

// tabs / filtering / progress
let filter='spaces';
function setFilter(f){filter=f;$$('#seg button').forEach(b=>b.classList.toggle('on',b.dataset.f===f));
 $('#trfilt').style.display=(f==='spaces')?'flex':'none';renderSection(f);update();}
function update(){for(const k in SEC)$('#'+SEC[k]).classList.toggle('hidden',filter!==k);
 const term=q.value.trim().toLowerCase(),hr=$('#hideRev').checked;let shown=0,rev=0,tot=0;const sec=$('#'+SEC[filter]);
 sec.querySelectorAll('.entry').forEach(e=>{tot++;const m=marks[idOf(e)];let ok=!term||e.dataset.search.includes(term);
  if(hr&&m)ok=false;e.classList.toggle('hidden',!ok);if(ok){shown++;if(m)rev++;}});
 $('#count').textContent=shown+' shown · '+rev+'/'+tot+' reviewed';focusFix();}
$$('#seg button').forEach(b=>b.onclick=()=>setFilter(b.dataset.f));
q.oninput=update;$('#hideRev').onchange=update;

// keyboard navigation
let cur=-1;
function visCards(){return $$('#'+SEC[filter]+' .entry:not(.hidden)');}
function focusCard(i){const v=visCards();if(!v.length)return;cur=Math.max(0,Math.min(i,v.length-1));
 v.forEach(e=>e.classList.remove('focused'));const e=v[cur];e.classList.add('focused');e.scrollIntoView({block:'center'});}
function focusFix(){const v=visCards();$$('.entry.focused').forEach(e=>{if(!v.includes(e))e.classList.remove('focused');});}
function nextUnrev(){const v=visCards();for(let k=1;k<=v.length;k++){const i=(cur+k)%v.length;if(!marks[idOf(v[i])]){focusCard(i);return;}}}
$('#btn-next').onclick=nextUnrev;
document.addEventListener('keydown',ev=>{if(/input|textarea/i.test(ev.target.tagName)){if(ev.key==='Escape')ev.target.blur();return;}
 const v=visCards();
 if(ev.key==='j')focusCard(cur+1);else if(ev.key==='k')focusCard(cur-1);
 else if(ev.key==='n')nextUnrev();
 else if(ev.key==='o'&&v[cur])setMark(v[cur],'ok');
 else if(ev.key==='f'&&v[cur])setMark(v[cur],'flag');
 else if(ev.key==='/'){ev.preventDefault();q.focus();return;}
 else if(ev.key==='?'){toggleHint();}
 else return;ev.preventDefault();});

// keyboard-shortcut legend
function toggleHint(){const hidden=$('#hint').classList.toggle('hidden');$('#hint-show').classList.toggle('hidden',!hidden);}
$('#hint-x').onclick=()=>{$('#hint').classList.add('hidden');$('#hint-show').classList.remove('hidden');};
$('#hint-show').onclick=()=>{$('#hint').classList.remove('hidden');$('#hint-show').classList.add('hidden');};

renderSection('spaces');refreshFlag();update();
// KaTeX loads deferred, so re-typeset already-rendered sections once it's ready
window.addEventListener('load',()=>{rendered.forEach(k=>typesetEl($('#'+SEC[k])));});
</script>'''


if __name__ == "__main__":
    main()

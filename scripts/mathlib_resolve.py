#!/usr/bin/env python3
"""
mathlib_resolve.py — resolve each pi-base→Mathlib mapping to the *actual* Mathlib
declaration: its fully-qualified name, source module, docstring + signature, and a
link to the Mathlib docs.

The registry (data/registry.json) is the canonical pi-base↔Mathlib link. This
script enriches it against a local Mathlib checkout and writes the standalone
artifact data/mathlib_links.json — the thing a code generator (or the review
sheet) consumes. The generated Lean `abbrev`s are just glue; the link is the point.

Usage:  python3 scripts/mathlib_resolve.py            # writes data/mathlib_links.json
        MATHLIB=/path/to/mathlib4 python3 scripts/mathlib_resolve.py
"""
import json
import os
import re
import shutil
import subprocess

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
REGISTRY = os.path.join(ROOT, "data", "registry.json")
DATA = os.path.join(ROOT, "data", "pibase.json")
OUT = os.path.join(ROOT, "data", "mathlib_links.json")
# Resolve against the Mathlib the project actually COMPILES against (the pinned
# .lake copy), not a stray checkout — otherwise decl names/versions drift.
_PIN = os.path.join(ROOT, ".lake", "packages", "mathlib")
MATHLIB = os.environ.get("MATHLIB") or (_PIN if os.path.isdir(_PIN)
                                        else "/Users/jack/Desktop/LEAN/mathlib4")
DOCS = "https://leanprover-community.github.io/mathlib4_docs"


def _find_url(fqn):
    """Version-agnostic docs redirect — resolves wherever the decl now lives."""
    return f"{DOCS}/find/?pattern={fqn}#doc"
GREP = "/usr/bin/grep"  # a real binary (`rg` is a shell function here)
KINDS = "class|structure|def|abbrev|inductive"

# name -> (relpath, line_idx0), filled lazily by one grep pass over Mathlib
_LOC_CACHE = None


def _locate_all(names):
    """One grep over Mathlib for all declaration sites; first hit per name."""
    names = sorted(set(names), key=len, reverse=True)  # longest-first alternation
    alt = "|".join(re.escape(n) for n in names)
    # allow an optional `@[…]` attribute prefix and a `_root_.` qualifier
    pat = rf"(^|\] )({KINDS}) (_root_\.)?({alt})([ (:]|$)"
    try:
        out = subprocess.run(
            [GREP, "-rEn", "--include=*.lean", pat, "Mathlib"],
            cwd=MATHLIB, capture_output=True, text=True, timeout=120).stdout
    except Exception:
        return {}
    loc = {}
    line_re = re.compile(rf"(?:^|\] )({KINDS}) (?:_root_\.)?(\w[\w.]*)")
    for row in out.splitlines():
        try:
            relpath, lineno, content = row.split(":", 2)
        except ValueError:
            continue
        m = line_re.search(content)
        if not m:
            continue
        nm = m.group(2)
        if nm in names and nm not in loc:
            loc[nm] = (relpath, int(lineno) - 1)
    return loc


def _rg_decl(name):
    """First declaration site of `name` in Mathlib: (relpath, line_idx0)."""
    global _LOC_CACHE
    if _LOC_CACHE is None:
        _LOC_CACHE = {}
    if name not in _LOC_CACHE:
        _LOC_CACHE.update(_locate_all([name]))
        _LOC_CACHE.setdefault(name, None)
    return _LOC_CACHE.get(name)


def _namespace_at(lines, idx):
    """Enclosing namespace prefix for the declaration at line `idx`."""
    stack = []
    for ln in lines[:idx]:
        s = ln.strip()
        m = re.match(r"namespace\s+([\w.]+)", s)
        if m:
            stack.extend(m.group(1).split("."))
            continue
        m = re.match(r"end\s+([\w.]+)", s)
        if m:
            for part in reversed(m.group(1).split(".")):
                if stack and stack[-1] == part:
                    stack.pop()
    return ".".join(stack)


def _extract(lines, idx):
    """(docstring, signature) around the declaration at line `idx`."""
    # docstring: skip attribute lines upward, then grab a /-- ... -/ block
    doc = []
    j = idx - 1
    while j >= 0 and (lines[j].lstrip().startswith("@[") or lines[j].strip() == ""):
        j -= 1
    if j >= 0 and lines[j].rstrip().endswith("-/"):
        k = j
        while k >= 0 and "/--" not in lines[k] and "/-!" not in lines[k]:
            k -= 1
        if k >= 0:
            doc = lines[k:j + 1]
    # signature: decl line through the first `where`/`:=`, plus indented fields
    sig = []
    decl_indent = len(lines[idx]) - len(lines[idx].lstrip())
    i = idx
    ended = False
    while i < len(lines) and len(sig) < 14:
        sig.append(lines[i])
        if re.search(r"\bwhere\b", lines[i]) or ":=" in lines[i]:
            ended = True
            i += 1
            break
        i += 1
    if ended and sig and re.search(r"\bwhere\b", sig[-1]):
        # include the field block
        while i < len(lines) and len(sig) < 14:
            if lines[i].strip() == "":
                break
            ind = len(lines[i]) - len(lines[i].lstrip())
            if ind <= decl_indent:
                break
            sig.append(lines[i])
            i += 1
    return "\n".join(doc).rstrip(), "\n".join(sig).rstrip()


def resolve_decl(name):
    """Full resolution for a Mathlib declaration name (short or qualified)."""
    short = name.split(".")[-1]
    hit = _rg_decl(short)
    if not hit:
        return {"name": name, "found": False,
                "docs_url": f"{DOCS}/find/?pattern={name}#doc"}
    relpath, idx = hit
    lines = open(os.path.join(MATHLIB, relpath)).read().splitlines()
    # a `_root_.Name` declaration lives in the root namespace regardless of context
    ns = "" if f"_root_.{short}" in lines[idx] else _namespace_at(lines, idx)
    fqn = f"{ns}.{short}" if ns else short
    doc, sig = _extract(lines, idx)
    module = relpath[:-5] if relpath.endswith(".lean") else relpath  # drop .lean
    return {
        "name": short, "fqn": fqn, "found": True,
        "module": module.replace("/", "."),
        "source": f"{relpath}:{idx + 1}",
        "docstring": doc, "signature": sig,
        "docs_url": f"{DOCS}/{module}.html#{fqn}",
    }


def primary_decls_in_expr(expr):
    """Capitalized identifiers referenced by an `expr` mapping (e.g. `Joined`)."""
    toks = re.findall(r"\b([A-Z][A-Za-z0-9_.]*)\b", expr)
    seen, out = set(), []
    for t in toks:
        if len(t) < 2 or t in seen:  # skip type variables like `X`
            continue
        seen.add(t); out.append(t)
    return out


def _prewarm(reg):
    """One grep pass to locate every decl the registry references."""
    global _LOC_CACHE
    names = []
    for e in reg.values():
        if "class" in e:
            names.append(e["class"].split(".")[-1])
        else:
            names.extend(primary_decls_in_expr(e["expr"]))
    _LOC_CACHE = _locate_all(names)


def _verify_docs(links):
    """Direct docs links are built from the pinned module path, but the docs site
    tracks master; a decl renamed/moved since the pin would 404. Curl each page
    and fall back to the version-agnostic `find` redirect for any that don't 200."""
    curl = shutil.which("curl")
    if not curl:
        return 0
    ms = []
    for v in links.values():
        m = v.get("mathlib")
        if m and m.get("found"):
            ms.append(m)
        for r in v.get("mathlib_refs", []) or []:
            if r.get("found"):
                ms.append(r)
    body, patched = {}, 0
    for m in ms:
        page, _, anchor = m["docs_url"].partition("#")
        if page not in body:
            try:
                body[page] = subprocess.run(
                    [curl, "-sfL", page], capture_output=True, text=True,
                    timeout=25).stdout
            except Exception:
                body[page] = ""
        # a direct link is good only if the page loaded AND carries the anchor
        if f'id="{anchor}"' not in body[page]:
            m["docs_url"] = _find_url(m["fqn"])
            patched += 1
    return patched


def main():
    reg = json.load(open(REGISTRY))["properties"]
    pname = {p["uid"]: p["name"] for p in json.load(open(DATA))["properties"]}
    _prewarm(reg)
    links = {}
    for uid, e in reg.items():
        entry = {"pibase_name": pname.get(uid, uid), "tier": e.get("tier"),
                 "note": e.get("note", "")}
        if "class" in e:
            entry["kind"] = "class"
            entry["mathlib"] = resolve_decl(e["class"])
        else:
            entry["kind"] = "expr"
            entry["expr"] = e["expr"]
            entry["mathlib_refs"] = [resolve_decl(d) for d in primary_decls_in_expr(e["expr"])]
        links[uid] = entry
    patched = _verify_docs(links)
    json.dump(links, open(OUT, "w"), indent=1, ensure_ascii=False)
    found = sum(1 for v in links.values()
                if (v.get("mathlib") or {}).get("found") or v.get("mathlib_refs"))
    src = "pinned .lake" if MATHLIB == _PIN else MATHLIB
    print(f"wrote {OUT}: {len(links)} mappings, {found} resolved ({src}); "
          f"{patched} docs link(s) → find-redirect")
    # report any unresolved for review
    for uid, v in links.items():
        m = v.get("mathlib")
        if m and not m.get("found"):
            print(f"  UNRESOLVED: {uid} -> {m['name']}")


if __name__ == "__main__":
    main()

import { AlertTriangle, Check, Download, ExternalLink, FileUp, Flag, Search } from "lucide-react";
import { useEffect, useMemo, useRef, useState } from "react";
import MathText from "../components/MathText";
import StatusBadge from "../components/StatusBadge";
import { downloadText, formatNumber, routeTo } from "../lib";
import type { DashboardData, LeanStatusName, ReviewChunkPayload, ReviewEntry, ReviewKind, ReviewPayload } from "../types";

type Mark = "ok" | "flag";
type MarkMap = Record<string, Mark>;
type StatusFilter = "all" | LeanStatusName;

const cache = new Map<ReviewKind, ReviewPayload>();
const chunkCache = new Map<string, ReviewEntry[]>();

function statusLabel(kind: ReviewKind, entry: { leanStatus: ReviewEntry["leanStatus"] }): string | undefined {
  if (
    kind === "properties"
    && entry.leanStatus.status === "local-debt"
    && entry.leanStatus.wellDefinedPlaceholders > 0
  ) return "Well-definedness debt";
  return undefined;
}

function readMarks(key: string): MarkMap {
  try { return JSON.parse(localStorage.getItem(key) ?? "{}") as MarkMap; }
  catch { return {}; }
}

export default function Review({ data, params }: { data: DashboardData; params: URLSearchParams }) {
  const initialKind = (["spaces", "properties", "theorems"] as ReviewKind[]).includes(params.get("kind") as ReviewKind)
    ? params.get("kind") as ReviewKind
    : "properties";
  const [kind, setKind] = useState<ReviewKind>(initialKind);
  const [query, setQuery] = useState(params.get("q") ?? "");
  const [status, setStatus] = useState<StatusFilter>("all");
  const [hideReviewed, setHideReviewed] = useState(false);
  const [limit, setLimit] = useState(24);
  const [payload, setPayload] = useState<ReviewPayload | null>(cache.get(initialKind) ?? null);
  const [loadedEntries, setLoadedEntries] = useState<Map<string, ReviewEntry>>(new Map());
  const [error, setError] = useState("");
  const marksKey = `pibase-review:${data.source.commit}`;
  const [marks, setMarks] = useState<MarkMap>(() => readMarks(marksKey));
  const searchRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    const onKey = (event: KeyboardEvent) => {
      if (event.key === "/" && !/input|textarea|select/i.test((event.target as HTMLElement).tagName)) {
        event.preventDefault();
        searchRef.current?.focus();
      }
    };
    document.addEventListener("keydown", onKey);
    return () => document.removeEventListener("keydown", onKey);
  }, []);

  useEffect(() => {
    let active = true;
    const seeded = new Map<string, ReviewEntry>();
    chunkCache.forEach((entries, key) => {
      if (key.startsWith(`${kind}:`)) entries.forEach((entry) => seeded.set(entry.id, entry));
    });
    setLoadedEntries(seeded);
    const cached = cache.get(kind);
    if (cached) {
      setPayload(cached);
      setError("");
      return () => { active = false; };
    }
    setPayload(null);
    fetch(new URL(`data/review-${kind}.json`, document.baseURI))
      .then((response) => {
        if (!response.ok) throw new Error(`Review data returned ${response.status}`);
        return response.json() as Promise<ReviewPayload>;
      })
      .then((next) => {
        if (next.kind !== kind) throw new Error(`Review index does not match ${kind}`);
        cache.set(kind, next);
        if (active) { setPayload(next); setError(""); }
      })
      .catch((reason: unknown) => {
        if (active) setError(reason instanceof Error ? reason.message : "Review data could not be loaded");
      });
    return () => { active = false; };
  }, [kind]);

  const filtered = useMemo(() => {
    if (!payload || payload.kind !== kind) return [];
    const term = query.trim().toLowerCase();
    const exactId = /^[pst]\d+$/.test(term);
    return payload.entries.filter((entry) => {
      if (status !== "all" && entry.leanStatus.status !== status) return false;
      if (hideReviewed && marks[entry.id]) return false;
      if (!term) return true;
      if (exactId) return entry.shortId.toLowerCase() === term;
      if (entry.id.toLowerCase() === term) return true;
      return [entry.shortId, entry.name, entry.author, ...entry.aliases].join(" ").toLowerCase().includes(term);
    });
  }, [hideReviewed, kind, marks, payload, query, status]);

  useEffect(() => {
    if (!payload || payload.kind !== kind) return;
    let active = true;
    const payloadKind = payload.kind;
    const wanted = [...new Set(filtered.slice(0, limit).map((entry) => entry.chunk))];
    const missing = wanted.filter((chunk) => !chunkCache.has(`${payloadKind}:${chunk}`));
    if (!missing.length) return () => { active = false; };
    Promise.all(missing.map(async (chunk) => {
      const response = await fetch(new URL(payload.chunks[chunk], document.baseURI));
      if (!response.ok) throw new Error(`Review chunk returned ${response.status}`);
      const next = await response.json() as ReviewChunkPayload;
      if (next.kind !== payloadKind || next.chunk !== chunk) {
        throw new Error(`Review chunk ${chunk} does not match ${payloadKind}`);
      }
      chunkCache.set(`${payloadKind}:${chunk}`, next.entries);
      return next.entries;
    }))
      .then((groups) => {
        if (!active) return;
        setLoadedEntries((current) => {
          const next = new Map(current);
          groups.flat().forEach((entry) => next.set(entry.id, entry));
          return next;
        });
      })
      .catch((reason: unknown) => {
        if (active) setError(reason instanceof Error ? reason.message : "Review source could not be loaded");
      });
    return () => { active = false; };
  }, [filtered, kind, limit, payload]);

  function changeKind(next: ReviewKind) {
    setKind(next);
    setLimit(24);
    window.history.replaceState(null, "", routeTo("review", { kind: next, q: query || undefined }));
  }

  function setMark(entry: { id: string }, mark: Mark) {
    const next = { ...marks };
    if (next[entry.id] === mark) delete next[entry.id]; else next[entry.id] = mark;
    setMarks(next);
    localStorage.setItem(marksKey, JSON.stringify(next));
  }

  async function importMarks(file: File | undefined) {
    if (!file) return;
    try {
      const parsed = JSON.parse(await file.text()) as unknown;
      let imported: MarkMap;
      if (parsed && typeof parsed === "object" && "marks" in parsed) {
        const nested = (parsed as { marks?: unknown }).marks;
        imported = nested && typeof nested === "object" ? nested as MarkMap : {};
      } else {
        imported = parsed as MarkMap;
      }
      const next = { ...marks, ...imported };
      setMarks(next);
      localStorage.setItem(marksKey, JSON.stringify(next));
      setError("");
    } catch (reason) {
      setError(reason instanceof Error ? reason.message : "Review marks could not be imported");
    }
  }

  function exportMarks() {
    downloadText("pibase-review-marks.json", JSON.stringify({
      schemaVersion: 1,
      sourceCommit: data.source.commit,
      exportedAt: new Date().toISOString(),
      marks,
    }, null, 2));
  }

  const reviewedCount = payload?.entries.filter((entry) => marks[entry.id]).length ?? 0;
  const flaggedCount = Object.values(marks).filter((mark) => mark === "flag").length;

  return (
    <div className="page review-page">
      <header className="page-intro compact-intro">
        <div>
          <p className="eyebrow">Semantic verification</p>
          <h1>Review</h1>
          <p className="page-lede">Informal π-Base statements beside their Lean representation and dependency status.</p>
        </div>
        <div className="review-progress">
          <strong>{formatNumber(reviewedCount)}</strong>
          <span>/ {formatNumber(payload?.entries.length ?? 0)} reviewed</span>
          {flaggedCount > 0 && <small>{formatNumber(flaggedCount)} flagged</small>}
        </div>
      </header>

      <section className="review-toolbar toolbar" aria-label="Review filters">
        <div className="segmented review-kinds" aria-label="Review entity type">
          {(["spaces", "properties", "theorems"] as ReviewKind[]).map((item) => (
            <button key={item} type="button" aria-pressed={kind === item} onClick={() => changeKind(item)}>
              {item[0].toUpperCase() + item.slice(1)}
            </button>
          ))}
        </div>
        <label className="search-field review-search">
          <span className="sr-only">Search review entries</span>
          <Search size={16} aria-hidden="true" />
          <input ref={searchRef} aria-label="Search review entries" value={query} onChange={(event) => { setQuery(event.target.value); setLimit(24); }} placeholder="Exact ID, name, or author" />
          <kbd>/</kbd>
        </label>
        <label className="select-field">
          <span>Status</span>
          <select value={status} onChange={(event) => { setStatus(event.target.value as StatusFilter); setLimit(24); }}>
            <option value="all">All trust states</option>
            <option value="dependency-clean">Dependency-clean</option>
            <option value="dependency-debt">Dependency debt</option>
            <option value="local-debt">Local debt</option>
            <option value="missing-declaration">Missing declaration</option>
          </select>
        </label>
        <label className="check-field"><input type="checkbox" checked={hideReviewed} onChange={(event) => setHideReviewed(event.target.checked)} /><span>Hide reviewed</span></label>
        <div className="toolbar-spacer" />
        <label className="icon-button file-icon-button" aria-label="Import review marks" data-tooltip="Import marks">
          <FileUp size={17} />
          <input type="file" accept="application/json,.json" onChange={(event) => importMarks(event.target.files?.[0])} />
        </label>
        <button type="button" className="icon-button" aria-label="Export review marks" data-tooltip="Export marks" onClick={exportMarks}><Download size={17} /></button>
      </section>

      <div className="review-count-line">
        <span>{formatNumber(filtered.length)} matching entries</span>
        <span>Marks scoped to <code>{data.source.commitShort}</code></span>
      </div>
      {error && <p className="form-error">{error}</p>}
      {!payload && !error && <div className="loading-state">Loading {kind}…</div>}

      <section className="review-list">
        {filtered.slice(0, limit).map((summary) => {
          const entry = loadedEntries.get(summary.id);
          if (!entry) {
            return (
              <article key={summary.id} className="review-entry review-entry-loading">
                <header className="review-entry-head">
                  <a className="entry-id" href={summary.referenceUrl}><code>{summary.shortId}</code></a>
                  <div className="entry-title"><MathText text={summary.name} inline /></div>
                  <StatusBadge status={summary.leanStatus.status} label={statusLabel(kind, summary)} />
                </header>
                <div className="review-source-loading">Loading Lean source…</div>
              </article>
            );
          }
          return (
          <article key={entry.id} className={`review-entry mark-${marks[entry.id] ?? "none"}`}>
            <header className="review-entry-head">
              <a className="entry-id" href={entry.referenceUrl}><code>{entry.shortId}</code></a>
              <div className="entry-title"><MathText text={entry.name} inline /></div>
              {entry.author && <span className="author-name">{entry.author}</span>}
              <StatusBadge status={entry.leanStatus.status} label={statusLabel(kind, entry)} />
              <div className="entry-links">
                <a className="icon-link" href={entry.referenceUrl} aria-label={`Open ${entry.shortId} on π-Base`} data-tooltip="π-Base"><ExternalLink size={15} /></a>
                <a className="icon-link" href={entry.sourceUrl} aria-label={`Open ${entry.shortId} Lean source`} data-tooltip="Lean source"><code>λ</code></a>
              </div>
              <div className="review-actions">
                <button type="button" aria-pressed={marks[entry.id] === "ok"} onClick={() => setMark(entry, "ok")}><Check size={15} /> Reviewed</button>
                <button type="button" aria-pressed={marks[entry.id] === "flag"} onClick={() => setMark(entry, "flag")}><Flag size={15} /> Flag</button>
              </div>
            </header>
            <div className="review-panes">
              <div className="informal-pane">
                {kind === "properties" && entry.leanStatus.wellDefinedPlaceholders > 0 && (
                  <div className="audit-warning" role="note">
                    <AlertTriangle size={17} aria-hidden="true" />
                    <div>
                      <strong>Well-definedness proof incomplete</strong>
                      <span>
                        This property definition is counted as implemented, but {formatNumber(entry.leanStatus.wellDefinedPlaceholders)} <code>WellDefined</code> obligation{entry.leanStatus.wellDefinedPlaceholders === 1 ? "" : "s"} still {entry.leanStatus.wellDefinedPlaceholders === 1 ? "contains" : "contain"} an active <code>sorry</code> or <code>admit</code>.
                      </span>
                    </div>
                  </div>
                )}
                {kind === "properties" && entry.leanStatus.localPlaceholders > entry.leanStatus.wellDefinedPlaceholders && (
                  <div className="audit-warning" role="note">
                    <AlertTriangle size={17} aria-hidden="true" />
                    <div>
                      <strong>Additional local proof debt</strong>
                      <span>{formatNumber(entry.leanStatus.localPlaceholders - entry.leanStatus.wellDefinedPlaceholders)} local placeholder{entry.leanStatus.localPlaceholders - entry.leanStatus.wellDefinedPlaceholders === 1 ? " is" : "s are"} outside the property's well-definedness obligations.</span>
                    </div>
                  </div>
                )}
                {kind === "theorems" && (entry.leanStatus.localPlaceholders > 0 || entry.leanStatus.localAxioms > 0) && (
                  <div className="audit-warning" role="note">
                    <AlertTriangle size={17} aria-hidden="true" />
                    <div>
                      <strong>Excluded from the formal implication graph</strong>
                      <span>The theorem's own Lean files contain an active placeholder or explicit axiom.</span>
                    </div>
                  </div>
                )}
                {kind === "theorems" && entry.leanStatus.dependencyNonWellDefinedPlaceholders > 0 && (
                  <div className="audit-warning" role="note">
                    <AlertTriangle size={17} aria-hidden="true" />
                    <div>
                      <strong>Imported proof debt requires audit</strong>
                      <span>The import closure contains a placeholder unrelated to a property <code>WellDefined</code> obligation. This file-level audit does not establish that the theorem uses it.</span>
                    </div>
                  </div>
                )}
                {entry.description ? <MathText text={entry.description} /> : <p className="muted-copy">No informal description recorded.</p>}
                <dl className="entry-ledger">
                  <div><dt>Local placeholders</dt><dd>{entry.leanStatus.localPlaceholders}</dd></div>
                  <div><dt>Dependency placeholders</dt><dd>{entry.leanStatus.dependencyPlaceholders}</dd></div>
                  {kind === "properties" && <div><dt>Well-definedness placeholders</dt><dd>{entry.leanStatus.wellDefinedPlaceholders}</dd></div>}
                  {kind === "theorems" && <div><dt>Imported well-definedness debt</dt><dd>{entry.leanStatus.dependencyWellDefinedPlaceholders}</dd></div>}
                  {kind === "theorems" && <div><dt>Other imported placeholders</dt><dd>{entry.leanStatus.dependencyNonWellDefinedPlaceholders}</dd></div>}
                  <div><dt>Declaration</dt><dd>{entry.leanStatus.declarationPresent ? "Present" : "Missing"}</dd></div>
                </dl>
                {entry.traits && entry.traits.length > 0 && (
                  <details className="trait-details">
                    <summary>{formatNumber(entry.traits.length)} known traits</summary>
                    <table>
                      <tbody>
                        {entry.traits.map((trait) => (
                          <tr key={`${trait.property}-${trait.value}`}>
                            <td className={trait.value ? "trait-yes" : "trait-no"}>{trait.value ? "✓" : "×"}</td>
                            <td><a href={routeTo("review", { kind: "properties", q: trait.property.replace(/^P0+/, "P") })}>{trait.name}</a></td>
                            <td><span className="table-tag">{trait.status}</span></td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </details>
                )}
              </div>
              <div className="lean-pane"><pre><code>{entry.code || "-- No primary Lean source"}</code></pre></div>
            </div>
            {entry.extraCode && <details className="extra-code"><summary>Supporting lemmas</summary><pre><code>{entry.extraCode}</code></pre></details>}
          </article>
          );
        })}
      </section>

      {payload && !filtered.length && <div className="empty-state">No review entries match these filters.</div>}
      {limit < filtered.length && <div className="load-more"><button className="button" type="button" onClick={() => setLimit((value) => value + 24)}>Show 24 more</button></div>}
    </div>
  );
}

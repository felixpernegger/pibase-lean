import {
  ArrowRight,
  Download,
  ExternalLink,
  FilePlus2,
  Search,
} from "lucide-react";
import { useEffect, useMemo, useState } from "react";
import MathText from "../components/MathText";
import { downloadText, formatNumber, routeTo } from "../lib";
import type { DashboardBundle, FrontierItem, PropertyNode } from "../types";

type FrontierView = "formalized" | "pibase";
type DefinitionSortKey = "unlocks" | "gain" | "id";

interface DefinitionFrontierRow {
  property: PropertyNode;
  candidates: FrontierItem[];
  unlockable: FrontierItem[];
  sourceCount: number;
  targetCount: number;
  bestGain: number;
}

function resolvePropertyId(
  value: string | null,
  propertyMap: ReadonlyMap<string, PropertyNode>,
  shortIdMap: ReadonlyMap<string, string>,
): string {
  const normalized = value?.trim().toUpperCase();
  if (!normalized) return "";
  if (propertyMap.has(normalized)) return normalized;
  return shortIdMap.get(normalized) ?? "";
}

export default function Frontier({ bundle, params }: { bundle: DashboardBundle; params: URLSearchParams }) {
  const { data } = bundle;
  const propertyMap = useMemo(
    () => new Map(data.properties.map((item) => [item.id, item])),
    [data.properties],
  );
  const shortIdMap = useMemo(
    () => new Map(data.properties.map((item) => [item.shortId.toUpperCase(), item.id])),
    [data.properties],
  );
  const initialView: FrontierView = params.get("view") === "pibase" ? "pibase" : "formalized";
  const [view, setView] = useState<FrontierView>(initialView);
  const [limit, setLimit] = useState(60);
  const [definitionQuery, setDefinitionQuery] = useState("");
  const [definitionSort, setDefinitionSort] = useState<DefinitionSortKey>("unlocks");
  const [selectedDefinitionId, setSelectedDefinitionId] = useState(
    resolvePropertyId(params.get("definition"), propertyMap, shortIdMap),
  );
  const [definitionPairLimit, setDefinitionPairLimit] = useState(8);
  const rawFrontier = view === "formalized" ? data.graph.formalized.frontier : data.frontier;
  const activeFrontier = useMemo(
    () => rawFrontier.filter((item) => isDefinitionsReady(item)),
    [propertyMap, rawFrontier],
  );
  const paramKey = params.toString();

  useEffect(() => {
    const nextView: FrontierView = params.get("view") === "pibase" ? "pibase" : "formalized";
    setView(nextView);
    setLimit(60);
    const nextDefinition = resolvePropertyId(params.get("definition"), propertyMap, shortIdMap);
    setSelectedDefinitionId(nextDefinition);
    setDefinitionPairLimit(8);
    if (!nextDefinition) return;
    const frame = window.requestAnimationFrame(() => {
      document.getElementById("definition-frontier")?.scrollIntoView({ block: "start" });
    });
    return () => window.cancelAnimationFrame(frame);
  }, [paramKey, params, propertyMap, shortIdMap]);

  function isDefinitionsReady(item: FrontierItem): boolean {
    return Boolean(
      propertyMap.get(item.source)?.lean?.declarationPresent
      && propertyMap.get(item.target)?.lean?.declarationPresent,
    );
  }

  function isDefinitionsReadyAfter(item: FrontierItem, definitionId: string): boolean {
    return [item.source, item.target].every((id) => (
      id === definitionId || Boolean(propertyMap.get(id)?.lean?.declarationPresent)
    ));
  }

  const rankedFrontier = useMemo(
    () => [...activeFrontier].sort(
      (left, right) => right.closureGain - left.closureGain
        || left.source.localeCompare(right.source)
        || left.target.localeCompare(right.target),
    ),
    [activeFrontier],
  );

  const blockedFrontier = useMemo(
    () => rawFrontier.filter((item) => !isDefinitionsReady(item)),
    [propertyMap, rawFrontier],
  );

  const definitionRows = useMemo(() => {
    const rows = new Map<string, {
      property: PropertyNode;
      candidates: FrontierItem[];
      unlockable: FrontierItem[];
      sourceCount: number;
      targetCount: number;
    }>();

    blockedFrontier.forEach((item) => {
      const missingIds = [...new Set([item.source, item.target].filter(
        (id) => !propertyMap.get(id)?.lean?.declarationPresent,
      ))];
      missingIds.forEach((id) => {
        const property = propertyMap.get(id);
        if (!property) return;
        const row = rows.get(id) ?? {
          property,
          candidates: [],
          unlockable: [],
          sourceCount: 0,
          targetCount: 0,
        };
        row.candidates.push(item);
        if (missingIds.length === 1) row.unlockable.push(item);
        if (item.source === id) row.sourceCount += 1;
        if (item.target === id) row.targetCount += 1;
        rows.set(id, row);
      });
    });

    return [...rows.values()].map((row): DefinitionFrontierRow => {
      const candidateOrder = (left: FrontierItem, right: FrontierItem) => (
        Number(isDefinitionsReadyAfter(right, row.property.id)) - Number(isDefinitionsReadyAfter(left, row.property.id))
        || right.closureGain - left.closureGain
        || left.source.localeCompare(right.source)
        || left.target.localeCompare(right.target)
      );
      const candidates = [...row.candidates].sort(candidateOrder);
      const unlockable = [...row.unlockable].sort(
        (left, right) => right.closureGain - left.closureGain || left.source.localeCompare(right.source),
      );
      return {
        ...row,
        candidates,
        unlockable,
        bestGain: unlockable[0]?.closureGain ?? candidates[0]?.closureGain ?? 0,
      };
    });
  }, [blockedFrontier, propertyMap]);

  const visibleDefinitionRows = useMemo(() => {
    const term = definitionQuery.trim().toLowerCase();
    const rows = definitionRows.filter(({ property }) => (
      !term
      || [property.shortId, property.name, ...property.aliases]
        .join(" ")
        .toLowerCase()
        .includes(term)
    ));
    rows.sort((left, right) => {
      if (definitionSort === "gain") {
        return right.bestGain - left.bestGain
          || right.unlockable.length - left.unlockable.length
          || left.property.id.localeCompare(right.property.id);
      }
      if (definitionSort === "id") return left.property.id.localeCompare(right.property.id);
      return right.unlockable.length - left.unlockable.length
        || right.bestGain - left.bestGain
        || left.property.id.localeCompare(right.property.id);
    });
    return rows;
  }, [definitionQuery, definitionRows, definitionSort]);

  const selectedDefinition = visibleDefinitionRows.find(
    (row) => row.property.id === selectedDefinitionId,
  ) ?? visibleDefinitionRows[0] ?? null;
  const immediatelyUnlockedCount = definitionRows.reduce(
    (total, row) => total + row.unlockable.length,
    0,
  );

  function selectView(nextView: FrontierView) {
    setView(nextView);
    setLimit(60);
    setSelectedDefinitionId("");
    setDefinitionPairLimit(8);
    window.history.replaceState(null, "", routeTo("frontier", {
      view: nextView === "pibase" ? "pibase" : undefined,
    }));
  }

  function exportFrontier(format: "json" | "csv") {
    const basename = view === "formalized" ? "pibase-formalization-frontier" : "pibase-unclassified-frontier";
    if (format === "json") {
      downloadText(`${basename}.json`, JSON.stringify(rankedFrontier, null, 2));
      return;
    }
    const rows = ["source,target,closure_gain,source_ancestors,target_descendants,pibase_status,conditional_evidence,axioms"];
    rankedFrontier.forEach((item) => rows.push([
      item.source,
      item.target,
      item.closureGain,
      item.sourceAncestors,
      item.targetDescendants,
      item.pibaseStatus ?? "",
      item.conditionalEvidence ?? false,
      (item.axioms ?? []).join("+"),
    ].join(",")));
    downloadText(`${basename}.csv`, rows.join("\n"), "text/csv");
  }

  const first = rankedFrontier[0];
  const firstSource = first ? propertyMap.get(first.source)! : null;
  const firstTarget = first ? propertyMap.get(first.target)! : null;

  return (
    <div className="page frontier-page">
      <header className="page-intro compact-intro">
        <div>
          <p className="eyebrow">{view === "formalized" ? "Lean graph" : "π-Base graph"}</p>
          <h1>{view === "formalized" ? "Formalization frontier" : "Research frontier"}</h1>
          <p className="page-lede">
            {view === "formalized"
              ? "Known π-Base implications with both endpoint definitions in Lean, ranked by formal closure gain."
              : "Unclassified π-Base implications with both endpoint definitions in Lean, ranked by potential closure gain."}
          </p>
        </div>
        <div className="frontier-intro-actions">
          <div className="segmented" aria-label="Frontier source">
            {(["formalized", "pibase"] as FrontierView[]).map((option) => (
              <button key={option} type="button" aria-pressed={view === option} onClick={() => selectView(option)}>
                {option === "formalized" ? "Formalization" : "π-Base"}
              </button>
            ))}
          </div>
          <div className="frontier-total">
            <strong>{formatNumber(rankedFrontier.length)}</strong>
            <span>proof-ready pairs</span>
          </div>
        </div>
      </header>

      {first && firstSource && firstTarget && (
        <section className="frontier-top-pick" aria-label="Highest-impact frontier candidate">
          <div className="frontier-top-label">
            <span>{view === "formalized" ? "Highest-impact target" : "Highest-impact question"}</span>
            <small>Ranked by closure impact</small>
          </div>
          <div className="frontier-top-pair">
            <div>
              <code>{firstSource.shortId}</code>
              <span>{view === "formalized" ? "⇒" : "⇒?"}</span>
              <code>{firstTarget.shortId}</code>
              {view === "formalized" && (
                <span className="table-tag">π-Base {first.pibaseStatus === "direct" ? "theorem" : "closure"}</span>
              )}
            </div>
            <p>
              <MathText text={firstSource.name} inline />
              <ArrowRight size={14} aria-hidden="true" />
              <MathText text={firstTarget.name} inline />
            </p>
          </div>
          <div className="frontier-top-impact">
            <strong>+{formatNumber(first.closureGain)}</strong>
            <span>{view === "formalized" ? "Lean pairs unlocked" : "cells if true"}</span>
          </div>
          <a className="button button-primary" href={routeTo("overview", {
            source: first.source,
            target: first.target,
            view: view === "pibase" ? "pibase" : undefined,
          })}>
            Inspect candidate <ArrowRight size={16} aria-hidden="true" />
          </a>
        </section>
      )}

      <div className="frontier-results-heading">
        <div>
          <p className="eyebrow">Proof frontier</p>
          <h2>{formatNumber(rankedFrontier.length)} candidate implications</h2>
        </div>
        <div className="frontier-results-actions">
          <button
            type="button"
            className="button frontier-definition-jump"
            onClick={() => document.getElementById("definition-frontier")?.scrollIntoView({ behavior: "smooth" })}
          >
            <FilePlus2 size={16} aria-hidden="true" />
            {formatNumber(definitionRows.length)} missing definitions
          </button>
          <div className="frontier-downloads">
            <button className="icon-button" type="button" aria-label="Download frontier as CSV" data-tooltip="Download CSV" onClick={() => exportFrontier("csv")}><Download size={17} /></button>
            <button className="icon-button" type="button" aria-label="Download frontier as JSON" data-tooltip="Download JSON" onClick={() => exportFrontier("json")}><span className="json-icon">{`{}`}</span></button>
          </div>
        </div>
      </div>

      <section className="frontier-table-wrap">
        <table className="data-table frontier-table">
          <thead>
            <tr>
              <th scope="col">Implication</th>
              <th scope="col">Hypothesis</th>
              <th scope="col">Conclusion</th>
              <th scope="col">{view === "formalized" ? "Lean closure gain" : "Potential closure gain"}</th>
            </tr>
          </thead>
          <tbody>
            {rankedFrontier.slice(0, limit).map((item) => {
              const source = propertyMap.get(item.source)!;
              const target = propertyMap.get(item.target)!;
              const key = `${item.source}|${item.target}`;
              return (
                <tr key={key}>
                  <td>
                    <a className="pair-cell" href={routeTo("overview", {
                      source: item.source,
                      target: item.target,
                      view: view === "pibase" ? "pibase" : undefined,
                    })}>
                      <code>{source.shortId}</code><span>{view === "formalized" ? "⇒" : "⇒?"}</span><code>{target.shortId}</code>
                      {view === "formalized" && (
                        <span className="table-tag">π-Base {item.pibaseStatus === "direct" ? "theorem" : "closure"}</span>
                      )}
                      {view === "pibase" && item.conditionalEvidence && (
                        <span className="table-tag">{(item.axioms ?? []).join(" + ")} counterexample</span>
                      )}
                    </a>
                  </td>
                  <td><MathText text={source.name} inline /></td>
                  <td><MathText text={target.name} inline /></td>
                  <td>
                    <strong>{formatNumber(item.closureGain)}</strong>
                    <span className="cell-detail">
                      {view === "formalized"
                        ? "pairs resolved if formalized"
                        : `${formatNumber(item.sourceAncestors)} ancestors · ${formatNumber(item.targetDescendants)} descendants`}
                      </span>
                  </td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </section>

      {limit < rankedFrontier.length && (
        <div className="load-more"><button type="button" className="button" onClick={() => setLimit((value) => value + 60)}>Show 60 more</button></div>
      )}

      <section className="definition-frontier" id="definition-frontier" aria-labelledby="definition-frontier-title">
        <header className="definition-frontier-heading">
          <div>
            <p className="eyebrow">Definition frontier</p>
            <h2 id="definition-frontier-title">{formatNumber(definitionRows.length)} missing definitions</h2>
            <p>
              These properties do not yet have Lean declarations, so their implications stay out of the proof frontier.
            </p>
          </div>
          <div className="definition-frontier-summary" aria-label="Definition frontier totals">
            <div>
              <strong>{formatNumber(definitionRows.length)}</strong>
              <span>missing definitions</span>
            </div>
            <div>
              <strong>{formatNumber(blockedFrontier.length)}</strong>
              <span>blocked pairs</span>
            </div>
            <div>
              <strong>{formatNumber(immediatelyUnlockedCount)}</strong>
              <span>one definition away</span>
            </div>
          </div>
        </header>

        <div className="definition-frontier-toolbar">
          <label className="search-field definition-search">
            <span className="sr-only">Search missing definitions</span>
            <Search size={16} aria-hidden="true" />
            <input
              type="search"
              value={definitionQuery}
              onChange={(event) => {
                setDefinitionQuery(event.target.value);
                setDefinitionPairLimit(8);
              }}
              placeholder="Search missing definitions"
            />
          </label>
          <div className="field-group definition-sort">
            <span>Rank definitions by</span>
            <div className="segmented">
              <button type="button" aria-pressed={definitionSort === "unlocks"} onClick={() => setDefinitionSort("unlocks")}>
                Targets unlocked
              </button>
              <button type="button" aria-pressed={definitionSort === "gain"} onClick={() => setDefinitionSort("gain")}>
                Best gain
              </button>
              <button type="button" aria-pressed={definitionSort === "id"} onClick={() => setDefinitionSort("id")}>
                Property
              </button>
            </div>
          </div>
        </div>

        <div className="definition-frontier-workspace">
          <nav className="definition-frontier-list" aria-label="Missing definitions">
            {visibleDefinitionRows.map((row) => (
              <button
                type="button"
                key={row.property.id}
                aria-pressed={selectedDefinition?.property.id === row.property.id}
                onClick={() => {
                  setSelectedDefinitionId(row.property.id);
                  setDefinitionPairLimit(8);
                }}
              >
                <div className="definition-list-title">
                  <code>{row.property.shortId}</code>
                  <MathText text={row.property.name} inline />
                </div>
                <div className="definition-list-metrics">
                  <span><strong>{formatNumber(row.unlockable.length)}</strong> immediate targets</span>
                  <small>{formatNumber(row.candidates.length)} affected · best +{formatNumber(row.bestGain)}</small>
                </div>
              </button>
            ))}
            {!visibleDefinitionRows.length && (
              <div className="definition-list-empty">No missing definitions match this search.</div>
            )}
          </nav>

          {selectedDefinition ? (
            <article className="definition-inspector">
              <header>
                <div>
                  <p className="eyebrow">Selected definition</p>
                  <h3>
                    <code>{selectedDefinition.property.shortId}</code>
                    <MathText text={selectedDefinition.property.name} inline />
                  </h3>
                </div>
                <a
                  className="icon-link"
                  href={selectedDefinition.property.referenceUrl}
                  target="_blank"
                  rel="noreferrer"
                  aria-label={`Open ${selectedDefinition.property.shortId} in π-Base`}
                  data-tooltip="Open π-Base entry"
                >
                  <ExternalLink size={17} aria-hidden="true" />
                </a>
              </header>

              {selectedDefinition.property.description && (
                <div className="definition-description">
                  <MathText text={selectedDefinition.property.description} />
                </div>
              )}

              <dl className="definition-impact-ledger">
                <div>
                  <dt>Immediate targets</dt>
                  <dd>{formatNumber(selectedDefinition.unlockable.length)}</dd>
                </div>
                <div>
                  <dt>All affected</dt>
                  <dd>{formatNumber(selectedDefinition.candidates.length)}</dd>
                </div>
                <div>
                  <dt>Hypothesis / conclusion</dt>
                  <dd>{formatNumber(selectedDefinition.sourceCount)} / {formatNumber(selectedDefinition.targetCount)}</dd>
                </div>
                <div>
                  <dt>Best immediate gain</dt>
                  <dd>+{formatNumber(selectedDefinition.bestGain)}</dd>
                </div>
              </dl>

              <div className="definition-targets-heading">
                <div>
                  <p className="eyebrow">Affected implications</p>
                  <h4>Proof targets</h4>
                </div>
                <span>
                  {formatNumber(Math.min(definitionPairLimit, selectedDefinition.candidates.length))}
                  {" of "}
                  {formatNumber(selectedDefinition.candidates.length)}
                </span>
              </div>

              <div className="definition-target-list">
                {selectedDefinition.candidates.slice(0, definitionPairLimit).map((item) => {
                  const source = propertyMap.get(item.source)!;
                  const target = propertyMap.get(item.target)!;
                  const otherMissing = [...new Set([source, target]
                    .filter((property) => (
                      property.id !== selectedDefinition.property.id
                      && !property.lean?.declarationPresent
                    ))
                    .map((property) => property.shortId))];
                  return (
                    <a
                      key={`${item.source}|${item.target}`}
                      href={routeTo("overview", {
                        source: item.source,
                        target: item.target,
                        view: view === "pibase" ? "pibase" : undefined,
                      })}
                    >
                      <div className="definition-target-pair">
                        <div>
                          <code>{source.shortId}</code>
                          <span>{view === "formalized" ? "⇒" : "⇒?"}</span>
                          <code>{target.shortId}</code>
                          {view === "formalized" && (
                            <span className="table-tag">π-Base {item.pibaseStatus === "direct" ? "theorem" : "closure"}</span>
                          )}
                        </div>
                        <p>
                          <MathText text={source.name} inline />
                          <ArrowRight size={13} aria-hidden="true" />
                          <MathText text={target.name} inline />
                        </p>
                      </div>
                      <div className="definition-target-impact">
                        <strong>+{formatNumber(item.closureGain)}</strong>
                        <small>{otherMissing.length ? `Also needs ${otherMissing.join(" + ")}` : "Ready after definition"}</small>
                      </div>
                      <ArrowRight size={17} aria-hidden="true" />
                    </a>
                  );
                })}
              </div>

              {definitionPairLimit < selectedDefinition.candidates.length && (
                <button
                  type="button"
                  className="button definition-show-more"
                  onClick={() => setDefinitionPairLimit((current) => current + 12)}
                >
                  Show more targets
                </button>
              )}
            </article>
          ) : (
            <div className="definition-inspector-empty">Select a missing definition to inspect its proof targets.</div>
          )}
        </div>
      </section>
    </div>
  );
}

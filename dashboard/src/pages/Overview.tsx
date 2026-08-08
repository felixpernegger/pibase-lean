import {
  ArrowRight,
  CheckCircle2,
  ExternalLink,
  GitBranch,
  GitCommitHorizontal,
  Repeat2,
  ShieldCheck,
} from "lucide-react";
import { lazy, Suspense, useEffect, useMemo, useState } from "react";
import ImplementationBar from "../components/ImplementationBar";
import Matrix, { type MatrixView } from "../components/Matrix";
import Metric from "../components/Metric";
import PropertyCombobox from "../components/PropertyCombobox";
import TheoremTrace, { TheoremLinks } from "../components/TheoremTrace";
import {
  FORMAL_GRAPH_STATUS,
  GRAPH_STATUS,
  findProofPath,
  formatNumber,
  formatPercent,
  graphIndex,
  graphStatusLabel,
  routeTo,
  type GraphStatusCode,
} from "../lib";
import type { DashboardBundle } from "../types";

const MathText = lazy(() => import("../components/MathText"));

const PIBASE_STATUS_CLASS: Record<number, string> = {
  0: "diagonal",
  1: "explicit-true",
  2: "derived-true",
  3: "false",
  4: "independent",
  5: "unclassified",
};

function statusClass(view: MatrixView, state: GraphStatusCode): string {
  if (view === "formalized") {
    if (state === 1) return "formal-direct";
    if (state === 2) return "formal-derived";
    return state === 0 ? "diagonal" : "unformalized";
  }
  return PIBASE_STATUS_CLASS[state];
}

function conditionLabel(condition: string): string {
  return condition.replace(/^not\s+/i, "¬");
}

export default function Overview({ bundle, params }: { bundle: DashboardBundle; params: URLSearchParams }) {
  const { data } = bundle;
  const [matrixView, setMatrixView] = useState<MatrixView>(params.get("view") === "pibase" ? "pibase" : "formalized");
  const [frontierView, setFrontierView] = useState<MatrixView>("formalized");
  const lead = data.graph.formalized.direct[0]
    ?? data.frontier[0]
    ?? { source: data.properties[0].id, target: data.properties[0].id };
  const validIds = useMemo(() => new Set(data.properties.map((item) => item.id)), [data.properties]);
  const [source, setSource] = useState(validIds.has(params.get("source") ?? "") ? params.get("source")! : lead.source);
  const [target, setTarget] = useState(validIds.has(params.get("target") ?? "") ? params.get("target")! : lead.target);
  const propertyNames = new Map(data.properties.map((item) => [item.id, item]));
  const formalDirectCount = data.graph.formalized.counts.formalizedDirect ?? 0;
  const formalDerivedCount = data.graph.formalized.counts.formalizedDerived ?? 0;
  const formalPairCount = formalDirectCount + formalDerivedCount;
  const sourceIndex = data.properties.findIndex((item) => item.id === source);
  const targetIndex = data.properties.findIndex((item) => item.id === target);
  const sourceNode = data.properties[sourceIndex];
  const targetNode = data.properties[targetIndex];
  const missingEndpointDefinitions = [sourceNode, targetNode].filter(
    (property) => !property.lean?.declarationPresent,
  );
  const pairDefinitionsReady = missingEndpointDefinitions.length === 0;
  const activeOutcomes = matrixView === "formalized" ? bundle.formalizedOutcomes : bundle.outcomes;
  const activeDirect = matrixView === "formalized" ? data.graph.formalized.direct : data.graph.direct;
  const state = activeOutcomes[graphIndex(data.graph.size, sourceIndex, targetIndex)] as GraphStatusCode;
  const pibaseState = bundle.outcomes[graphIndex(data.graph.size, sourceIndex, targetIndex)] as GraphStatusCode;
  const statusLabels = matrixView === "formalized" ? FORMAL_GRAPH_STATUS : GRAPH_STATUS;
  const direct = activeDirect.find((edge) => edge.source === source && edge.target === target);
  const pibaseDirect = data.graph.direct.find((edge) => edge.source === source && edge.target === target);
  const formalEdge = data.graph.formalized.direct.find((edge) => edge.source === source && edge.target === target);
  const path = state === 2 ? findProofPath(data, source, target, activeDirect) : [];
  const pibasePath = pibaseState === 2 ? findProofPath(data, source, target, data.graph.direct) : [];
  const witnessValue = bundle.witnesses[graphIndex(data.graph.size, sourceIndex, targetIndex)];
  const witness = witnessValue ? data.spaces[witnessValue - 1] : null;
  const formalFrontier = state === 5
    ? data.graph.formalized.frontier.find((item) => item.source === source && item.target === target)
    : null;
  const pibaseFrontier = pibaseState === 5
    ? data.frontier.find((item) => item.source === source && item.target === target)
    : null;
  const axiomDependency = data.graph.axiomDependencies.find(
    (item) => item.source === source && item.target === target,
  );
  const conditionalEvidence = data.graph.conditionalEvidence.find(
    (item) => item.source === source && item.target === target,
  );
  const proofReadyPreview = (
    frontierView === "formalized" ? data.graph.formalized.frontier : data.frontier
  ).filter((item) => (
    propertyNames.get(item.source)?.lean?.declarationPresent
    && propertyNames.get(item.target)?.lean?.declarationPresent
  ));
  const outcomeLabel = matrixView === "formalized"
    ? statusLabels[state].label
    : graphStatusLabel(data, state, source, target);
  const paramKey = params.toString();

  useEffect(() => {
    const nextSource = params.get("source");
    const nextTarget = params.get("target");
    setMatrixView(params.get("view") === "pibase" ? "pibase" : "formalized");
    if (!nextSource || !nextTarget || !validIds.has(nextSource) || !validIds.has(nextTarget)) return;
    setSource(nextSource);
    setTarget(nextTarget);
    const frame = window.requestAnimationFrame(() => {
      document.getElementById("implication-explorer")?.scrollIntoView({ block: "start" });
    });
    return () => window.cancelAnimationFrame(frame);
  }, [paramKey, params, validIds]);

  function selectPair(nextSource: string, nextTarget: string) {
    setSource(nextSource);
    setTarget(nextTarget);
    window.history.replaceState(null, "", routeTo("overview", {
      source: nextSource,
      target: nextTarget,
      view: matrixView === "pibase" ? "pibase" : undefined,
    }));
  }

  function selectMatrixView(nextView: MatrixView) {
    setMatrixView(nextView);
    window.history.replaceState(null, "", routeTo("overview", {
      source,
      target,
      view: nextView === "pibase" ? "pibase" : undefined,
    }));
  }

  return (
    <div className="page overview-page">
      <header className="page-intro overview-intro">
        <div>
          <p className="eyebrow">Lean 4 · Mathlib · topology</p>
          <h1>pibase-lean</h1>
          <p className="page-lede">
            Formalizing the implication graph of π-Base.
          </p>
        </div>
      </header>

      <section className="metric-grid" aria-label="Project status">
        <Metric
          label="Lean-resolved pairs"
          value={formatNumber(formalPairCount)}
          detail={`${formatPercent(formalPairCount, data.summary.totalPairs, 2)} of ${formatNumber(data.summary.totalPairs)} ordered pairs`}
          tone="clean"
          icon={<ShieldCheck size={18} aria-hidden="true" />}
        />
        <Metric
          label="Direct Lean edges"
          value={formatNumber(formalDirectCount)}
          detail="Positive single-property implications"
          tone="represented"
          icon={<GitCommitHorizontal size={18} aria-hidden="true" />}
        />
        <Metric
          label="By transitive closure"
          value={formatNumber(formalDerivedCount)}
          detail="Composed from direct Lean proofs"
          tone="graph"
          icon={<GitBranch size={18} aria-hidden="true" />}
        />
        <Metric
          label="Properties implemented"
          value={formatPercent(data.summary.propertyImplementations, data.summary.propertyTotal)}
          detail={`${formatNumber(data.summary.propertyImplementations)} definitions · ${formatNumber(data.summary.propertyTotal - data.summary.propertyImplementations)} remaining`}
          tone="open"
          icon={<CheckCircle2 size={18} aria-hidden="true" />}
        />
      </section>

      <section id="implication-explorer" className="dashboard-section section-graph">
        <div className="section-heading">
          <div>
            <p className="eyebrow">Implication graph</p>
            <h2>Explorer</h2>
          </div>
          <div className="explorer-heading-actions">
            <div className="segmented" aria-label="Implication source">
              {(["formalized", "pibase"] as MatrixView[]).map((view) => (
                <button
                  key={view}
                  type="button"
                  aria-pressed={matrixView === view}
                  onClick={() => selectMatrixView(view)}
                >
                  {view === "formalized" ? "Formalized" : "π-Base"}
                </button>
              ))}
            </div>
            <div className={`outcome-chip graph-${statusClass(matrixView, state)}`}>
              <i className={`matrix-swatch graph-${statusClass(matrixView, state)}`} aria-hidden="true" />
              {outcomeLabel}
            </div>
          </div>
        </div>

        <div className="pair-controls" aria-label="Selected implication">
          <PropertyCombobox
            id="source-property"
            label="Hypothesis"
            value={source}
            properties={data.properties}
            onChange={(nextSource) => selectPair(nextSource, target)}
          />
          <button
            type="button"
            className="icon-button swap-button"
            aria-label="Swap hypothesis and conclusion"
            data-tooltip="Swap direction"
            onClick={() => selectPair(target, source)}
          >
            <Repeat2 size={18} aria-hidden="true" />
          </button>
          <PropertyCombobox
            id="target-property"
            label="Conclusion"
            value={target}
            properties={data.properties}
            onChange={(nextTarget) => selectPair(source, nextTarget)}
          />
        </div>

        <div className="explorer-layout">
          <div className="matrix-workspace">
            <div className="matrix-toolbar">
              <span>
                {matrixView === "formalized"
                  ? `${formatNumber(formalDirectCount)} proved directly · ${formatNumber(formalDerivedCount)} by transitivity`
                  : `${formatNumber(data.graph.counts.explicitTrue)} direct · ${formatNumber(data.graph.counts.derivedTrue)} by closure`}
              </span>
            </div>
            <Matrix
              bundle={bundle}
              selectedSource={source}
              selectedTarget={target}
              onSelect={selectPair}
              outcomes={activeOutcomes}
              view={matrixView}
            />
          </div>

          <aside className="pair-inspector" aria-label="Pair evidence">
            <div className="inspector-head">
              <p className="eyebrow">Selected pair</p>
              <div className="pair-equation"><code>{sourceNode.shortId}</code><span>⇒</span><code>{targetNode.shortId}</code></div>
            </div>

            <Suspense fallback={<div className="property-summary-loading" aria-hidden="true" />}>
              <div className="property-summary">
                <div>
                  <span>Hypothesis</span>
                  <h2><MathText text={sourceNode.name} inline /></h2>
                  <MathText text={sourceNode.description} />
                  <a href={sourceNode.referenceUrl}>π-Base <ExternalLink size={13} aria-hidden="true" /></a>
                </div>
                <div>
                  <span>Conclusion</span>
                  <h2><MathText text={targetNode.name} inline /></h2>
                  <MathText text={targetNode.description} />
                  <a href={targetNode.referenceUrl}>π-Base <ExternalLink size={13} aria-hidden="true" /></a>
                </div>
              </div>
            </Suspense>

            <div className="evidence-block">
              <h3>Evidence</h3>
              {matrixView === "formalized" ? (
                <>
                  {state === 0 && <p>The hypothesis and conclusion are the same property.</p>}
                  {state === 1 && (
                    <div>
                      <p>Proved by a canonical Lean theorem with no local <code>sorry</code>, <code>admit</code>, or explicit axiom.</p>
                      <TheoremLinks data={data} theoremIds={direct?.theorems ?? []} view="formalized" />
                    </div>
                  )}
                  {state === 2 && (
                    <div>
                      <p>Derived by transitivity across {Math.max(0, path.length - 1)} Lean-proved edges.</p>
                      <TheoremTrace data={data} path={path} directEdges={activeDirect} view="formalized" />
                    </div>
                  )}
                  {state === 5 && (
                    <div>
                      <p>No canonical pairwise Lean theorem path is currently recorded for this implication.</p>
                      <dl className="frontier-evidence">
                        <div><dt>π-Base classification</dt><dd>{graphStatusLabel(data, pibaseState, source, target)}</dd></div>
                        {formalFrontier && <div><dt>Lean closure gain</dt><dd>{formatNumber(formalFrontier.closureGain)}</dd></div>}
                        {!pairDefinitionsReady && (
                          <div>
                            <dt>Definition status</dt>
                            <dd>Needs {missingEndpointDefinitions.map((property) => property.shortId).join(" + ")}</dd>
                          </div>
                        )}
                      </dl>
                      {formalFrontier && pibaseState === 1 && (
                        <div className="lean-implementation-links">
                          <span>π-Base theorem evidence</span>
                          <TheoremLinks data={data} theoremIds={pibaseDirect?.theorems ?? []} view="pibase" />
                        </div>
                      )}
                      {formalFrontier && pibaseState === 2 && (
                        <div className="lean-implementation-links">
                          <span>π-Base transitive trace</span>
                          <TheoremTrace data={data} path={pibasePath} directEdges={data.graph.direct} view="pibase" />
                        </div>
                      )}
                      {formalFrontier && !pairDefinitionsReady && (
                        <a className="text-link" href={routeTo("frontier", {
                          definition: missingEndpointDefinitions[0].id,
                        })}>
                          View in definition frontier
                          <ArrowRight size={15} aria-hidden="true" />
                        </a>
                      )}
                    </div>
                  )}
                </>
              ) : (
                <>
                  {state === 0 && <p>The hypothesis and conclusion are the same property.</p>}
                  {state === 1 && (
                    <div>
                      <p>Recorded as a direct π-Base theorem edge.</p>
                      <TheoremLinks data={data} theoremIds={direct?.theorems ?? []} view="pibase" />
                      {formalEdge && (
                        <div className="lean-implementation-links">
                          <span>Lean implementation</span>
                          <TheoremLinks data={data} theoremIds={formalEdge.theorems} view="formalized" />
                        </div>
                      )}
                    </div>
                  )}
                  {state === 2 && (
                    <div>
                      <p>Derived from {Math.max(0, path.length - 1)} explicit π-Base theorem edges.</p>
                      <TheoremTrace data={data} path={path} directEdges={activeDirect} view="pibase" />
                    </div>
                  )}
                  {state === 3 && witness && (
                    <div className="witness-evidence">
                      <p>An unconditional separating space satisfies the hypothesis and refutes the conclusion.</p>
                      <a href={witness.referenceUrl}><code>{witness.shortId}</code><strong>{witness.name}</strong><ExternalLink size={14} aria-hidden="true" /></a>
                    </div>
                  )}
                  {state === 4 && axiomDependency && (
                    <div className="axiom-evidence">
                      <p><strong>Independent of {axiomDependency.baseTheory}.</strong> {axiomDependency.summary}</p>
                      <dl className="frontier-evidence">
                        {axiomDependency.trueWhen && <div><dt>True under</dt><dd>{conditionLabel(axiomDependency.trueWhen)}</dd></div>}
                        {axiomDependency.falseWhen && <div><dt>False under</dt><dd>{conditionLabel(axiomDependency.falseWhen)}</dd></div>}
                      </dl>
                      <TheoremLinks data={data} theoremIds={axiomDependency.theorems} view="pibase" />
                    </div>
                  )}
                  {state === 5 && pibaseFrontier && (
                    <div>
                      <p>No unconditional theorem path, unconditional separating space, or axiom-dependence certificate is currently recorded.</p>
                      {conditionalEvidence && (
                        <div className="conditional-evidence">
                          <span>Conditional evidence</span>
                          {conditionalEvidence.witnesses.map((item) => {
                            const conditionalWitness = data.spaces.find((space) => space.id === item.space);
                            if (!conditionalWitness) return null;
                            return (
                              <a key={item.space} href={item.referenceUrl}>
                                <code>{conditionalWitness.shortId}</code>
                                <strong>{conditionalWitness.name}</strong>
                                <small>Counterexample under {item.condition || item.assumptions.join(" + ")}</small>
                                <ExternalLink size={14} aria-hidden="true" />
                              </a>
                            );
                          })}
                          <p>This conditional witness does not determine the implication without the stated assumption.</p>
                        </div>
                      )}
                      <dl className="frontier-evidence">
                        <div><dt>Potential closure gain</dt><dd>{formatNumber(pibaseFrontier.closureGain)}</dd></div>
                        <div><dt>Known ancestors</dt><dd>{formatNumber(pibaseFrontier.sourceAncestors)}</dd></div>
                        <div><dt>Known descendants</dt><dd>{formatNumber(pibaseFrontier.targetDescendants)}</dd></div>
                        {!pairDefinitionsReady && (
                          <div>
                            <dt>Definition status</dt>
                            <dd>Needs {missingEndpointDefinitions.map((property) => property.shortId).join(" + ")}</dd>
                          </div>
                        )}
                      </dl>
                      <a className="text-link" href={routeTo("implications", { hyp: source, concl: target })}>
                        Check under community assertions
                        <ArrowRight size={15} aria-hidden="true" />
                      </a>
                      {!pairDefinitionsReady && (
                        <a className="text-link" href={routeTo("frontier", {
                          definition: missingEndpointDefinitions[0].id,
                          view: "pibase",
                        })}>
                          View in definition frontier
                          <ArrowRight size={15} aria-hidden="true" />
                        </a>
                      )}
                    </div>
                  )}
                </>
              )}
            </div>

            <div className="inspector-actions">
              <a href={routeTo("review", { kind: "properties", q: sourceNode.shortId })}><GitBranch size={15} aria-hidden="true" /> Review {sourceNode.shortId}</a>
              <a href={routeTo("review", { kind: "properties", q: targetNode.shortId })}><GitBranch size={15} aria-hidden="true" /> Review {targetNode.shortId}</a>
            </div>
          </aside>
        </div>
      </section>

      <section className="dashboard-section section-split">
        <div className="section-heading">
          <div>
            <p className="eyebrow">π-Base dataset</p>
            <h2>Formalization coverage</h2>
            <p className="section-summary">Each bar compares Felix's Lean formalizations with every record in the pinned π-Base dataset.</p>
          </div>
          <a className="text-link" href={routeTo("review")}>Open review <ArrowRight size={15} aria-hidden="true" /></a>
        </div>
        <div className="trust-ledger">
          <ImplementationBar
            label="Properties"
            implemented={data.summary.propertyImplementations}
            total={data.summary.propertyTotal}
          />
          <ImplementationBar
            label="Theorem records"
            implemented={data.summary.theoremImplementations}
            total={data.summary.theoremTotal}
          />
          <ImplementationBar
            label="Spaces"
            implemented={data.summary.spaceImplementations}
            total={data.summary.spaceTotal}
          />
        </div>
      </section>

      <section className="dashboard-section two-column-section">
        <div>
          <div className="section-heading">
            <div>
              <p className="eyebrow">{frontierView === "formalized" ? "Formalization frontier" : "π-Base frontier"}</p>
              <h2>{frontierView === "formalized" ? "Highest-leverage proofs" : "Largest potential gain"}</h2>
            </div>
            <div className="section-heading-actions">
              <div className="segmented" aria-label="Frontier source">
                {(["formalized", "pibase"] as MatrixView[]).map((view) => (
                  <button key={view} type="button" aria-pressed={frontierView === view} onClick={() => setFrontierView(view)}>
                    {view === "formalized" ? "Formalization" : "π-Base"}
                  </button>
                ))}
              </div>
              <a className="text-link" href={routeTo("frontier", { view: frontierView === "pibase" ? "pibase" : undefined })}>
                View all <ArrowRight size={15} aria-hidden="true" />
              </a>
            </div>
          </div>
          <ol className="frontier-preview">
            {proofReadyPreview.slice(0, 6).map((item) => {
              const source = propertyNames.get(item.source)!;
              const target = propertyNames.get(item.target)!;
              return (
                <li key={`${item.source}-${item.target}`}>
                  <a href={routeTo("overview", {
                    source: item.source,
                    target: item.target,
                    view: frontierView === "pibase" ? "pibase" : undefined,
                  })}>
                    <span className="pair-label"><code>{source.shortId}</code> <span>{frontierView === "formalized" ? "⇒" : "⇒?"}</span> <code>{target.shortId}</code></span>
                    <span className="pair-names">{source.name} → {target.name}</span>
                    <span className="gain">
                      +{formatNumber(item.closureGain)} {frontierView === "formalized" ? "Lean pairs" : "cells if true"}
                    </span>
                  </a>
                </li>
              );
            })}
          </ol>
        </div>
        <div>
          <div className="section-heading">
            <div>
              <p className="eyebrow">Repository</p>
              <h2>Recent activity</h2>
            </div>
          </div>
          <ol className="activity-list">
            {data.recentActivity.slice(0, 6).map((commit) => (
              <li key={commit.sha}>
                <GitCommitHorizontal size={16} aria-hidden="true" />
                <div>
                  <a href={`${data.project.repoUrl}/commit/${commit.sha}`}>{commit.subject}</a>
                  <span><code>{commit.short}</code> · {commit.date}</span>
                </div>
              </li>
            ))}
          </ol>
        </div>
      </section>
    </div>
  );
}

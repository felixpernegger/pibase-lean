import {
  ArrowRight,
  CheckCircle2,
  Dices,
  ExternalLink,
  FlaskConical,
  Gauge,
  ListChecks,
  MessageSquarePlus,
  Repeat2,
  Send,
  Trash2,
  XCircle,
} from "lucide-react";
import { Fragment, lazy, Suspense, useEffect, useMemo, useRef, useState } from "react";
import Metric from "../components/Metric";
import PropertyCombobox from "../components/PropertyCombobox";
import StatusBadge from "../components/StatusBadge";
import {
  findModel,
  makeIndex,
  propagate,
  propagateProof,
  recloseModels,
  valToModel,
  drawOpenTriple,
} from "../engine";
import { formatNumber, routeTo, shortUid } from "../lib";
import type {
  AcceptedAssertion,
  DashboardBundle,
  ImplicationAtom,
  ImplicationPair,
  ImplicationsData,
  LocalAssertion,
  PropertyNode,
  ReviewEntrySummary,
  ReviewPayload,
} from "../types";

const MathText = lazy(() => import("../components/MathText"));

const PIBASE_URL = "https://topology.pi-base.org";
const LOCAL_KEY = "pibase-lean:local-assertions";
// deduce.py's EXCLUDED set: P164 ("has multiple points") skews random draws.
const EXCLUDED_PROPS = new Set(["P000164"]);

let payloadCache: ImplicationsData | null = null;
let theoremCache: Map<string, ReviewEntrySummary> | null = null;

type ClauseSource =
  | { kind: "theorem"; id: string }
  | { kind: "accepted"; index: number }
  | { kind: "local"; index: number };

type ModelSource =
  | { kind: "space"; uid: string; name: string }
  | { kind: "accepted"; index: number }
  | { kind: "local"; index: number };

interface Derived {
  clauses: number[][];
  byProp: number[][];
  models: string[];
  clauseSources: ClauseSource[];
  modelSources: ModelSource[];
  openPairs: Array<{ pair: ImplicationPair; lits: [number, number] }>;
  localTrue: ImplicationPair[];
  counts: { provable: number; refuted: number; unknown: number };
  stale: Map<number, string>;
}

type Verdict =
  | { kind: "idle" }
  | { kind: "refuted"; witness: ModelSource }
  | { kind: "provable"; sources: ClauseSource[]; theoremsOnly: boolean }
  | { kind: "open" };

function atomsOf(value: ImplicationAtom | ImplicationAtom[]): ImplicationAtom[] {
  return Array.isArray(value) ? value : [value];
}

function readLocalAssertions(): LocalAssertion[] {
  try {
    const parsed = JSON.parse(localStorage.getItem(LOCAL_KEY) ?? "[]") as LocalAssertion[];
    return Array.isArray(parsed) ? parsed : [];
  } catch {
    return [];
  }
}

function shortStatement(hyps: ImplicationAtom[], concl: ImplicationAtom): string {
  const literal = (atom: ImplicationAtom) => `${atom.value ? "" : "~"}${shortUid(atom.uid)}`;
  return `${hyps.map(literal).join(" + ")} => ${literal(concl)}`;
}

function markdownStatement(hyps: ImplicationAtom[], concl: ImplicationAtom): string {
  const literal = (atom: ImplicationAtom) =>
    `${atom.value ? "" : "¬"}[${atom.name}](${PIBASE_URL}/properties/${atom.uid})`;
  return `${hyps.map(literal).join(" ∧ ")} ⇒ ${literal(concl)}`;
}

// The statement:/verdict:/note: lines are the machine contract parsed by
// pibase-data's scripts/assertion_issue.py; everything else is presentation.
function submissionUrl(repo: string, pending: LocalAssertion[]): string {
  const lines = ["Verdicts submitted from the website:", ""];
  pending.forEach((assertion, index) => {
    lines.push(
      `**${index + 1}.** ${markdownStatement(assertion.if, assertion.then)} — **${assertion.holds ? "true" : "false"}**`,
      "",
      `statement: ${shortStatement(assertion.if, assertion.then)}`,
      `verdict: ${assertion.holds ? "true" : "false"}`,
      `note: ${assertion.note}`,
      "",
    );
  });
  const count = pending.length;
  const title = `[assertion${count > 1 ? "s" : ""}] ${count} verdict${count > 1 ? "s" : ""} from the website`;
  const query = new URLSearchParams({ title, body: lines.join("\n") });
  return `https://github.com/${repo}/issues/new?${query}`;
}

function parseLiteralParam(raw: string | null, valid: Set<string>): { uid: string; value: boolean } | null {
  if (!raw) return null;
  const value = !raw.startsWith("!");
  const uid = value ? raw : raw.slice(1);
  return valid.has(uid) ? { uid, value } : null;
}

function literalParam(uid: string, value: boolean): string {
  return `${value ? "" : "!"}${uid}`;
}

function replay(payload: ImplicationsData, locals: LocalAssertion[]): Derived {
  const propCount = payload.prop_ids.length;
  const propIndex = new Map(payload.prop_ids.map((uid, index) => [uid, index]));
  const litOf = (atom: { uid: string; value: boolean }) =>
    2 * propIndex.get(atom.uid)! + (atom.value ? 0 : 1);

  let clauses = payload.clauses;
  let byProp = makeIndex(clauses, propCount);
  let models = payload.models.slice();
  const clauseSources: ClauseSource[] = payload.clause_ids.map((id) => {
    const accepted = /^assertion #(\d+)$/.exec(id);
    return accepted ? { kind: "accepted", index: Number(accepted[1]) } : { kind: "theorem", id };
  });
  const modelSources: ModelSource[] = payload.model_meta.map((meta) =>
    meta.kind === "space" ? { kind: "space", uid: meta.uid, name: meta.name } : { kind: "accepted", index: meta.index },
  );
  const stale = new Map<number, string>();

  locals.forEach((assertion, index) => {
    if ([...assertion.if, assertion.then].some((atom) => !propIndex.has(atom.uid))) {
      stale.set(index, "references a property that is no longer in the dataset");
      return;
    }
    const hypLits = assertion.if.map(litOf);
    const conclLit = litOf(assertion.then);
    const seed = [...hypLits, conclLit ^ 1];
    if (findModel(models, seed) >= 0) {
      stale.set(index, assertion.holds
        ? "now refuted by a known counterexample, so your true verdict was dropped"
        : "already refuted, so your verdict is no longer needed");
      return;
    }
    if (propagate(clauses, byProp, propCount, seed).contradiction) {
      stale.set(index, assertion.holds
        ? "already provable, so your verdict is no longer needed"
        : "now provable, so your false verdict was dropped");
      return;
    }
    if (assertion.holds) {
      const clause = [...hypLits.map((lit) => lit ^ 1), conclLit];
      const nextClauses = [...clauses, clause];
      const nextByProp = makeIndex(nextClauses, propCount);
      const reclosed = recloseModels(models, nextClauses, nextByProp, propCount);
      if (!reclosed) {
        stale.set(index, "contradicts a known space, so it was dropped");
        return;
      }
      clauses = nextClauses;
      byProp = nextByProp;
      models = reclosed;
      clauseSources.push({ kind: "local", index });
    } else {
      const closure = propagate(clauses, byProp, propCount, seed);
      models = [...models, valToModel(closure.val)];
      modelSources.push({ kind: "local", index });
    }
  });

  const openPairs: Derived["openPairs"] = [];
  const localTrue: ImplicationPair[] = [];
  let refutedNow = 0;
  for (const pair of payload.pairs) {
    const hypLit = litOf(atomsOf(pair.if)[0]);
    const conclLit = litOf(pair.then);
    if (findModel(models, [hypLit, conclLit ^ 1]) >= 0) {
      refutedNow += 1;
    } else if (propagate(clauses, byProp, propCount, [hypLit, conclLit ^ 1]).contradiction) {
      localTrue.push(pair);
    } else {
      openPairs.push({ pair, lits: [hypLit, conclLit] });
    }
  }

  return {
    clauses,
    byProp,
    models,
    clauseSources,
    modelSources,
    openPairs,
    localTrue,
    counts: {
      provable: payload.counts.provable + localTrue.length,
      refuted: payload.counts.refuted + refutedNow,
      unknown: openPairs.length,
    },
    stale,
  };
}

function LiteralText({ atom }: { atom: ImplicationAtom }) {
  return (
    <span className="implication-literal">
      {!atom.value && <span className="literal-negation" aria-label="not">¬</span>}
      <Suspense fallback={<span>{atom.name}</span>}>
        <MathText text={atom.name} inline />
      </Suspense>
    </span>
  );
}

function StatementText({ hyps, concl }: { hyps: ImplicationAtom[]; concl: ImplicationAtom }) {
  return (
    <span className="implication-statement">
      {hyps.map((atom, index) => (
        <Fragment key={`${atom.uid}-${atom.value}`}>
          {index > 0 && <span className="statement-connective">∧</span>}
          <LiteralText atom={atom} />
        </Fragment>
      ))}
      <span className="statement-connective">⇒</span>
      <LiteralText atom={concl} />
    </span>
  );
}

function NegationToggle({ label, value, onChange }: { label: string; value: boolean; onChange: (next: boolean) => void }) {
  return (
    <button
      type="button"
      className="negation-toggle"
      aria-pressed={value}
      aria-label={`Negate ${label}`}
      data-tooltip={value ? "Negated — click to affirm" : "Click to negate"}
      onClick={() => onChange(!value)}
    >
      ¬
    </button>
  );
}

export default function Implications({ bundle, params }: { bundle: DashboardBundle; params: URLSearchParams }) {
  const [payload, setPayload] = useState<ImplicationsData | null>(payloadCache);
  const [error, setError] = useState("");
  const [theorems, setTheorems] = useState<Map<string, ReviewEntrySummary> | null>(theoremCache);
  const [locals, setLocals] = useState<LocalAssertion[]>(readLocalAssertions);

  const [hyp, setHyp] = useState("");
  const [hypNegated, setHypNegated] = useState(false);
  const [hyp2, setHyp2] = useState("");
  const [hyp2Negated, setHyp2Negated] = useState(false);
  const [concl, setConcl] = useState("");
  const [conclNegated, setConclNegated] = useState(false);
  const [verdictNote, setVerdictNote] = useState("");
  const [assertError, setAssertError] = useState("");

  const [query, setQuery] = useState("");
  const [limit, setLimit] = useState(25);
  const [sort, setSort] = useState<"default" | "ifTrue" | "ifFalse">("default");
  const [scores, setScores] = useState<{ ifTrue: number[]; ifFalse: number[] } | null>(null);
  const [scoring, setScoring] = useState(false);
  const workerRef = useRef<Worker | null>(null);
  const checkerRef = useRef<HTMLElement>(null);

  useEffect(() => {
    if (payloadCache) return;
    let active = true;
    fetch(new URL("data/implications.json", document.baseURI))
      .then((response) => {
        if (!response.ok) throw new Error(`Implications data returned ${response.status}`);
        return response.json() as Promise<ImplicationsData>;
      })
      .then((next) => {
        payloadCache = next;
        if (active) setPayload(next);
      })
      .catch((reason: unknown) => {
        if (active) setError(reason instanceof Error ? reason.message : "Implications data could not be loaded");
      });
    return () => { active = false; };
  }, []);

  useEffect(() => {
    if (theoremCache) return;
    let active = true;
    fetch(new URL("data/review-theorems.json", document.baseURI))
      .then((response) => (response.ok ? (response.json() as Promise<ReviewPayload>) : null))
      .then((next) => {
        if (!next) return;
        theoremCache = new Map(next.entries.map((entry) => [entry.id, entry]));
        if (active) setTheorems(theoremCache);
      })
      .catch(() => undefined); // Lean badges are progressive enhancement
    return () => { active = false; };
  }, []);

  useEffect(() => {
    localStorage.setItem(LOCAL_KEY, JSON.stringify(locals));
  }, [locals]);

  useEffect(() => () => workerRef.current?.terminate(), []);

  const derived = useMemo(() => (payload ? replay(payload, locals) : null), [payload, locals]);

  const propIndex = useMemo(
    () => new Map((payload?.prop_ids ?? []).map((uid, index) => [uid, index])),
    [payload],
  );
  const propertyNodes = useMemo<PropertyNode[]>(
    () =>
      (payload?.prop_ids ?? []).map((uid, index) => ({
        id: uid,
        shortId: shortUid(uid),
        name: payload!.prop_names[index],
        aliases: [],
        description: "",
        lean: null,
        registry: null,
        referenceUrl: `${PIBASE_URL}/properties/${uid}`,
      })),
    [payload],
  );
  const propNodesById = useMemo(
    () => new Map(propertyNodes.map((node) => [node.id, node])),
    [propertyNodes],
  );
  const dashboardProperties = useMemo(
    () => new Set(bundle.data.properties.map((property) => property.id)),
    [bundle.data.properties],
  );

  const atomOf = useMemo(() => (uid: string, value: boolean): ImplicationAtom => ({
    uid,
    value,
    name: propNodesById.get(uid)?.name ?? uid,
  }), [propNodesById]);

  const paramKey = params.toString();
  useEffect(() => {
    if (!payload) return;
    const valid = new Set(payload.prop_ids);
    const nextHyp = parseLiteralParam(params.get("hyp"), valid);
    const nextConcl = parseLiteralParam(params.get("concl"), valid);
    if (!nextHyp || !nextConcl) return;
    const nextHyp2 = parseLiteralParam(params.get("hyp2"), valid);
    setHyp(nextHyp.uid);
    setHypNegated(!nextHyp.value);
    setHyp2(nextHyp2?.uid ?? "");
    setHyp2Negated(nextHyp2 ? !nextHyp2.value : false);
    setConcl(nextConcl.uid);
    setConclNegated(!nextConcl.value);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [paramKey, payload]);

  function syncUrl(next: { hyp?: string; hypNegated?: boolean; hyp2?: string; hyp2Negated?: boolean; concl?: string; conclNegated?: boolean }) {
    const state = {
      hyp: next.hyp ?? hyp,
      hypNegated: next.hypNegated ?? hypNegated,
      hyp2: next.hyp2 ?? hyp2,
      hyp2Negated: next.hyp2Negated ?? hyp2Negated,
      concl: next.concl ?? concl,
      conclNegated: next.conclNegated ?? conclNegated,
    };
    if (!state.hyp || !state.concl) return;
    window.history.replaceState(null, "", routeTo("implications", {
      hyp: literalParam(state.hyp, !state.hypNegated),
      hyp2: state.hyp2 ? literalParam(state.hyp2, !state.hyp2Negated) : undefined,
      concl: literalParam(state.concl, !state.conclNegated),
    }));
  }

  function loadStatement(hyps: ImplicationAtom[], conclusion: ImplicationAtom) {
    const [first, second] = hyps;
    setHyp(first.uid);
    setHypNegated(!first.value);
    setHyp2(second?.uid ?? "");
    setHyp2Negated(second ? !second.value : false);
    setConcl(conclusion.uid);
    setConclNegated(!conclusion.value);
    setVerdictNote("");
    setAssertError("");
    syncUrl({
      hyp: first.uid,
      hypNegated: !first.value,
      hyp2: second?.uid ?? "",
      hyp2Negated: second ? !second.value : false,
      concl: conclusion.uid,
      conclNegated: !conclusion.value,
    });
    checkerRef.current?.scrollIntoView({ block: "start" });
  }

  const checkerAtoms = useMemo(() => {
    if (!payload || !hyp || !concl) return null;
    const hyps = [atomOf(hyp, !hypNegated)];
    if (hyp2 && hyp2 !== hyp) hyps.push(atomOf(hyp2, !hyp2Negated));
    return { hyps, concl: atomOf(concl, !conclNegated) };
  }, [payload, hyp, hypNegated, hyp2, hyp2Negated, concl, conclNegated, atomOf]);

  const verdict = useMemo<Verdict>(() => {
    if (!payload || !derived || !checkerAtoms) return { kind: "idle" };
    const litOf = (atom: ImplicationAtom) => 2 * propIndex.get(atom.uid)! + (atom.value ? 0 : 1);
    const seed = [...checkerAtoms.hyps.map(litOf), litOf(checkerAtoms.concl) ^ 1];
    const witnessIndex = findModel(derived.models, seed);
    if (witnessIndex >= 0) return { kind: "refuted", witness: derived.modelSources[witnessIndex] };
    const proof = propagateProof(derived.clauses, derived.byProp, payload.prop_ids.length, seed);
    if (proof.contradiction) {
      const sources = proof.used.map((index) => derived.clauseSources[index]);
      return { kind: "provable", sources, theoremsOnly: sources.every((source) => source.kind === "theorem") };
    }
    return { kind: "open" };
  }, [payload, derived, checkerAtoms, propIndex]);

  const filteredOpen = useMemo(() => {
    if (!derived) return [];
    const indexed = derived.openPairs.map((item, index) => ({ ...item, index }));
    const term = query.trim().toLowerCase();
    const matched = term
      ? indexed.filter(({ pair }) => {
        const haystack = [...atomsOf(pair.if), pair.then]
          .flatMap((atom) => [atom.name, atom.uid, shortUid(atom.uid)])
          .join(" ")
          .toLowerCase();
        return term.split(/\s+/).every((piece) => haystack.includes(piece));
      })
      : indexed;
    if (sort === "default" || !scores) return matched;
    const values = sort === "ifTrue" ? scores.ifTrue : scores.ifFalse;
    return [...matched].sort((left, right) => (values[right.index] ?? 0) - (values[left.index] ?? 0));
  }, [derived, query, sort, scores]);

  useEffect(() => {
    setScores(null);
    setScoring(false);
    workerRef.current?.terminate();
    workerRef.current = null;
  }, [derived]);

  function computeLeverage() {
    if (!payload || !derived || scoring || scores) return;
    setScoring(true);
    const worker = new Worker(new URL("../scoreWorker.ts", import.meta.url), { type: "module" });
    workerRef.current = worker;
    worker.onmessage = (event: MessageEvent<{ ifTrue: number[]; ifFalse: number[] }>) => {
      setScores(event.data);
      setScoring(false);
      worker.terminate();
      workerRef.current = null;
    };
    worker.postMessage({
      clauses: derived.clauses,
      propCount: payload.prop_ids.length,
      models: derived.models,
      pairLits: derived.openPairs.map((item) => item.lits),
    });
  }

  function randomOpenPair() {
    if (!derived?.openPairs.length) return;
    const { pair } = derived.openPairs[Math.floor(Math.random() * derived.openPairs.length)];
    loadStatement(atomsOf(pair.if), pair.then);
  }

  function randomOpenTriple() {
    if (!payload || !derived) return;
    const propsOk = payload.prop_ids
      .map((uid, index) => ({ uid, index }))
      .filter(({ uid }) => !EXCLUDED_PROPS.has(uid))
      .map(({ index }) => index);
    const triple = drawOpenTriple(derived.clauses, derived.byProp, payload.prop_ids.length, derived.models, propsOk);
    if (!triple) return;
    const toAtom = (lit: number) => atomOf(payload.prop_ids[lit >> 1], (lit & 1) === 0);
    loadStatement(triple.hyps.map(toAtom), toAtom(triple.concl));
  }

  function recordVerdict(holds: boolean) {
    if (!checkerAtoms || verdict.kind !== "open") return;
    if (!verdictNote.trim()) {
      setAssertError("A short justification is required — it becomes the review note.");
      return;
    }
    setAssertError("");
    setLocals((current) => [
      ...current,
      {
        if: checkerAtoms.hyps,
        then: checkerAtoms.concl,
        holds,
        note: verdictNote.trim(),
        date: new Date().toISOString().slice(0, 10),
        submitted: false,
      },
    ]);
    setVerdictNote("");
  }

  function submitPending() {
    if (!payload) return;
    const pending = locals.filter((assertion, index) => !assertion.submitted && !derived?.stale.has(index));
    if (!pending.length) return;
    window.open(submissionUrl(payload.repo, pending), "_blank", "noopener");
    setLocals((current) => current.map((assertion) => (assertion.submitted ? assertion : { ...assertion, submitted: true })));
  }

  if (error) {
    return (
      <div className="page implications-page">
        <header className="page-intro">
          <div>
            <p className="eyebrow">Community implications</p>
            <h1>Implications</h1>
            <p className="page-lede">{error}</p>
          </div>
        </header>
      </div>
    );
  }

  if (!payload || !derived) {
    return <div className="route-loading">Loading the implications engine…</div>;
  }

  const pendingCount = locals.filter((assertion, index) => !assertion.submitted && !derived.stale.has(index)).length;
  const settledLocally = [...derived.localTrue];

  return (
    <div className="page implications-page">
      <header className="page-intro">
        <div>
          <p className="eyebrow">Community implications</p>
          <h1>Open implications &amp; assertions</h1>
          <p className="page-lede">
            The deduction engine from{" "}
            <a href={`https://github.com/${payload.repo}`}>{payload.repo}</a> running over the same
            π-Base dataset: check any implication between property literals, browse what is still
            open, and submit true/false verdicts for community review. Accepted verdicts become
            permanent assertions alongside the formal Lean effort.
          </p>
        </div>
      </header>

      <section className="metric-grid" aria-label="Implications engine status">
        <Metric
          label="Open statements"
          value={formatNumber(derived.counts.unknown)}
          detail={`of ${formatNumber(payload.counts.total)} canonical literal pairs`}
          tone="open"
          icon={<FlaskConical size={18} aria-hidden="true" />}
        />
        <Metric
          label="Refuted"
          value={formatNumber(derived.counts.refuted)}
          detail={`Counterexamples across ${formatNumber(payload.spaces)} spaces`}
          tone="represented"
          icon={<XCircle size={18} aria-hidden="true" />}
        />
        <Metric
          label="Provable"
          value={formatNumber(derived.counts.provable)}
          detail="Forced by theorems and accepted assertions"
          tone="clean"
          icon={<CheckCircle2 size={18} aria-hidden="true" />}
        />
        <Metric
          label="Accepted assertions"
          value={formatNumber(payload.assertions.length)}
          detail={pendingCount ? `${formatNumber(pendingCount)} of yours pending` : "Community-reviewed verdicts"}
          tone="graph"
          icon={<ListChecks size={18} aria-hidden="true" />}
        />
      </section>

      {derived.stale.size > 0 && (
        <div className="stale-notice" role="status">
          <p>
            {formatNumber(derived.stale.size)} of your local verdicts no longer apply:
          </p>
          <ul>
            {[...derived.stale.entries()].map(([index, reason]) => (
              <li key={index}>
                <StatementText hyps={locals[index].if} concl={locals[index].then} /> — {reason}.
              </li>
            ))}
          </ul>
          <button
            type="button"
            className="button"
            onClick={() => setLocals((current) => current.filter((_, index) => !derived.stale.has(index)))}
          >
            Clear resolved verdicts
          </button>
        </div>
      )}

      <section ref={checkerRef} id="implication-checker" className="dashboard-section section-checker">
        <div className="section-heading">
          <div>
            <p className="eyebrow">Deduction engine</p>
            <h2>Check an implication</h2>
            <p className="section-summary">
              Statements range over property literals: negate either side, or add a second
              hypothesis for A ∧ B ⇒ C questions.
            </p>
          </div>
          <div className="section-heading-actions">
            <button type="button" className="button" onClick={randomOpenPair}>
              <Dices size={15} aria-hidden="true" /> Random open pair
            </button>
            <button type="button" className="button" onClick={randomOpenTriple}>
              <Dices size={15} aria-hidden="true" /> Random A ∧ B ⇒ C
            </button>
          </div>
        </div>

        <div className="checker-controls">
          <div className="checker-literal">
            <NegationToggle label="hypothesis" value={hypNegated} onChange={(next) => { setHypNegated(next); syncUrl({ hypNegated: next }); }} />
            <PropertyCombobox
              id="implication-hypothesis"
              label="Hypothesis"
              value={hyp}
              properties={propertyNodes}
              onChange={(next) => { setHyp(next); syncUrl({ hyp: next }); }}
            />
          </div>
          <div className="checker-literal">
            <NegationToggle label="second hypothesis" value={hyp2Negated} onChange={(next) => { setHyp2Negated(next); syncUrl({ hyp2Negated: next }); }} />
            <PropertyCombobox
              id="implication-hypothesis-2"
              label="And (optional)"
              value={hyp2}
              properties={propertyNodes}
              clearable
              onChange={(next) => { setHyp2(next); syncUrl({ hyp2: next }); }}
            />
          </div>
          <button
            type="button"
            className="icon-button swap-button"
            aria-label="Swap hypothesis and conclusion"
            data-tooltip="Swap direction"
            onClick={() => {
              if (!hyp || !concl) return;
              const nextHyp = concl;
              const nextHypNegated = conclNegated;
              setConcl(hyp);
              setConclNegated(hypNegated);
              setHyp(nextHyp);
              setHypNegated(nextHypNegated);
              syncUrl({ hyp: nextHyp, hypNegated: nextHypNegated, concl: hyp, conclNegated: hypNegated });
            }}
          >
            <Repeat2 size={18} aria-hidden="true" />
          </button>
          <div className="checker-literal">
            <NegationToggle label="conclusion" value={conclNegated} onChange={(next) => { setConclNegated(next); syncUrl({ conclNegated: next }); }} />
            <PropertyCombobox
              id="implication-conclusion"
              label="Conclusion"
              value={concl}
              properties={propertyNodes}
              onChange={(next) => { setConcl(next); syncUrl({ concl: next }); }}
            />
          </div>
        </div>

        {checkerAtoms && verdict.kind !== "idle" && (
          <div className={`checker-verdict verdict-${verdict.kind}`}>
            <div className="verdict-statement">
              <StatementText hyps={checkerAtoms.hyps} concl={checkerAtoms.concl} />
              <span className={`verdict-chip verdict-chip-${verdict.kind}`}>
                {verdict.kind === "provable" && "True"}
                {verdict.kind === "refuted" && "False"}
                {verdict.kind === "open" && "Open"}
              </span>
            </div>

            {verdict.kind === "provable" && (
              <div className="verdict-detail">
                <p>
                  {verdict.theoremsOnly
                    ? "Forced by π-Base theorems alone."
                    : "Forced by π-Base theorems together with accepted or local assertions."}
                </p>
                <ul className="proof-references">
                  {verdict.sources.map((source, index) => {
                    if (source.kind === "theorem") {
                      const review = theorems?.get(source.id);
                      return (
                        <li key={`${source.id}-${index}`}>
                          <a href={`${PIBASE_URL}/theorems/${source.id}`}>
                            <code>{shortUid(source.id)}</code>
                            <ExternalLink size={13} aria-hidden="true" />
                          </a>
                          {review && (
                            <a className="proof-lean-link" href={routeTo("review", { kind: "theorems", q: shortUid(source.id) })}>
                              <StatusBadge status={review.leanStatus.status} />
                            </a>
                          )}
                        </li>
                      );
                    }
                    if (source.kind === "accepted") {
                      const assertion = payload.assertions[source.index];
                      return (
                        <li key={`accepted-${source.index}`} className="proof-assertion">
                          <span className="assertion-tag">Accepted assertion #{source.index + 1}</span>
                          {assertion && <StatementText hyps={atomsOf(assertion.if)} concl={assertion.then} />}
                        </li>
                      );
                    }
                    return (
                      <li key={`local-${source.index}`} className="proof-assertion">
                        <span className="assertion-tag">Your local verdict</span>
                        {locals[source.index] && <StatementText hyps={locals[source.index].if} concl={locals[source.index].then} />}
                      </li>
                    );
                  })}
                </ul>
              </div>
            )}

            {verdict.kind === "refuted" && (
              <div className="verdict-detail">
                {verdict.witness.kind === "space" && (
                  <div className="witness-evidence">
                    <p>A known space satisfies the hypotheses and refutes the conclusion.</p>
                    <a href={`${PIBASE_URL}/spaces/${verdict.witness.uid}`}>
                      <code>{shortUid(verdict.witness.uid)}</code>
                      <strong><Suspense fallback={verdict.witness.name}><MathText text={verdict.witness.name} inline /></Suspense></strong>
                      <ExternalLink size={14} aria-hidden="true" />
                    </a>
                  </div>
                )}
                {verdict.witness.kind === "accepted" && payload.assertions[verdict.witness.index] && (
                  <div className="witness-evidence">
                    <p>Refuted by an accepted community assertion:</p>
                    <div className="assertion-citation">
                      <StatementText
                        hyps={atomsOf(payload.assertions[verdict.witness.index].if)}
                        concl={payload.assertions[verdict.witness.index].then}
                      />
                      <span className="verdict-chip verdict-chip-refuted">asserted false</span>
                      <small>{payload.assertions[verdict.witness.index].note} · {payload.assertions[verdict.witness.index].date}</small>
                    </div>
                  </div>
                )}
                {verdict.witness.kind === "local" && locals[verdict.witness.index] && (
                  <div className="witness-evidence">
                    <p>Refuted by one of your local verdicts:</p>
                    <div className="assertion-citation">
                      <StatementText hyps={locals[verdict.witness.index].if} concl={locals[verdict.witness.index].then} />
                      <span className="verdict-chip verdict-chip-refuted">yours · pending</span>
                    </div>
                  </div>
                )}
              </div>
            )}

            {verdict.kind === "open" && (
              <div className="verdict-detail">
                <p>
                  Neither provable nor refuted from the current data. If you can settle it,
                  record a verdict — it applies locally right away and can be submitted for
                  community review on GitHub.
                </p>
                <div className="assert-form">
                  <label htmlFor="verdict-note">Why? (proof sketch or counterexample)</label>
                  <textarea
                    id="verdict-note"
                    rows={2}
                    value={verdictNote}
                    placeholder="e.g. the one-point compactification of a discrete space works"
                    onChange={(event) => setVerdictNote(event.target.value)}
                  />
                  {assertError && <p className="assert-error" role="alert">{assertError}</p>}
                  <div className="assert-actions">
                    <button type="button" className="button verdict-true" onClick={() => recordVerdict(true)}>
                      <CheckCircle2 size={15} aria-hidden="true" /> Holds
                    </button>
                    <button type="button" className="button verdict-false" onClick={() => recordVerdict(false)}>
                      <XCircle size={15} aria-hidden="true" /> Fails
                    </button>
                  </div>
                </div>
              </div>
            )}

            {checkerAtoms.hyps.length === 1
              && checkerAtoms.hyps[0].value
              && checkerAtoms.concl.value
              && dashboardProperties.has(checkerAtoms.hyps[0].uid)
              && dashboardProperties.has(checkerAtoms.concl.uid) && (
              <a
                className="text-link"
                href={routeTo("overview", { source: checkerAtoms.hyps[0].uid, target: checkerAtoms.concl.uid })}
              >
                Open in the Lean implication explorer
                <ArrowRight size={15} aria-hidden="true" />
              </a>
            )}
          </div>
        )}
      </section>

      <section className="dashboard-section section-open-list">
        <div className="section-heading">
          <div>
            <p className="eyebrow">Frontier of the informal graph</p>
            <h2>Open implications</h2>
            <p className="section-summary">
              {formatNumber(filteredOpen.length)} statements no theorem proves and no space refutes.
            </p>
          </div>
          <div className="section-heading-actions">
            <button type="button" className="button" onClick={computeLeverage} disabled={scoring || !!scores}>
              <Gauge size={15} aria-hidden="true" />
              {scores ? "Leverage computed" : scoring ? "Computing…" : "Compute leverage"}
            </button>
          </div>
        </div>

        <div className="open-list-controls">
          <input
            type="search"
            value={query}
            placeholder="Filter by property name or P-number"
            aria-label="Filter open implications"
            onChange={(event) => { setQuery(event.target.value); setLimit(25); }}
          />
          {scores && (
            <div className="segmented" aria-label="Sort open implications">
              {([["default", "Original"], ["ifTrue", "Solves if true"], ["ifFalse", "Solves if false"]] as const).map(([value, label]) => (
                <button key={value} type="button" aria-pressed={sort === value} onClick={() => setSort(value)}>
                  {label}
                </button>
              ))}
            </div>
          )}
        </div>

        <table className="open-list-table">
          <thead>
            <tr>
              <th scope="col">Statement</th>
              {scores && <th scope="col" className="score-column">If true</th>}
              {scores && <th scope="col" className="score-column">If false</th>}
              <th scope="col" className="action-column"><span className="sr-only">Actions</span></th>
            </tr>
          </thead>
          <tbody>
            {filteredOpen.slice(0, limit).map(({ pair, index }) => (
              <tr key={`${atomsOf(pair.if)[0].uid}-${atomsOf(pair.if)[0].value}-${pair.then.uid}-${pair.then.value}`}>
                <td><StatementText hyps={atomsOf(pair.if)} concl={pair.then} /></td>
                {scores && (
                  <td className="score-column">
                    {scores.ifTrue[index] === -1 ? "—" : formatNumber(scores.ifTrue[index])}
                  </td>
                )}
                {scores && <td className="score-column">{formatNumber(scores.ifFalse[index])}</td>}
                <td className="action-column">
                  <button type="button" className="button" onClick={() => loadStatement(atomsOf(pair.if), pair.then)}>
                    Check
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
        {filteredOpen.length > limit && (
          <button type="button" className="button show-more" onClick={() => setLimit((current) => current + 50)}>
            Show more ({formatNumber(filteredOpen.length - limit)} remaining)
          </button>
        )}
      </section>

      <section className="dashboard-section two-column-section">
        <div>
          <div className="section-heading">
            <div>
              <p className="eyebrow">Community knowledge</p>
              <h2>Accepted assertions</h2>
              <p className="section-summary">
                Verdicts reviewed and merged into <a href={`https://github.com/${payload.repo}`}>{payload.repo}</a>.
              </p>
            </div>
          </div>
          <ol className="assertion-list">
            {payload.assertions.map((assertion: AcceptedAssertion, index) => (
              <li key={index}>
                <StatementText hyps={atomsOf(assertion.if)} concl={assertion.then} />
                <span className={`verdict-chip verdict-chip-${assertion.holds ? "provable" : "refuted"}`}>
                  {assertion.holds ? "true" : "false"}
                </span>
                <small>{assertion.note} · {assertion.date}</small>
              </li>
            ))}
          </ol>
        </div>
        <div>
          <div className="section-heading">
            <div>
              <p className="eyebrow">Settled by assertions</p>
              <h2>Newly provable</h2>
              <p className="section-summary">
                Open in π-Base alone, but forced once assertions are admitted.
              </p>
            </div>
          </div>
          <ol className="assertion-list">
            {payload.new_true.map((pair, index) => (
              <li key={`accepted-${index}`}>
                <StatementText hyps={atomsOf(pair.if)} concl={pair.then} />
                <span className="verdict-chip verdict-chip-provable">accepted</span>
                <button type="button" className="text-link why-link" onClick={() => loadStatement(atomsOf(pair.if), pair.then)}>
                  why?
                </button>
              </li>
            ))}
            {settledLocally.map((pair, index) => (
              <li key={`local-${index}`}>
                <StatementText hyps={atomsOf(pair.if)} concl={pair.then} />
                <span className="verdict-chip verdict-chip-pending">yours · pending</span>
                <button type="button" className="text-link why-link" onClick={() => loadStatement(atomsOf(pair.if), pair.then)}>
                  why?
                </button>
              </li>
            ))}
            {!payload.new_true.length && !settledLocally.length && (
              <li className="assertion-empty">Nothing yet — settle an open implication above.</li>
            )}
          </ol>
        </div>
      </section>

      <section className="dashboard-section section-local">
        <div className="section-heading">
          <div>
            <p className="eyebrow">Your workspace</p>
            <h2>Local verdicts</h2>
            <p className="section-summary">
              Stored in this browser and applied to the engine immediately. Submitting opens a
              pre-filled GitHub issue on {payload.repo}; maintainers review it before anything
              becomes permanent.
            </p>
          </div>
          <div className="section-heading-actions">
            <button type="button" className="button button-primary" onClick={submitPending} disabled={!pendingCount}>
              <Send size={15} aria-hidden="true" />
              Submit {pendingCount ? formatNumber(pendingCount) : ""} for review
            </button>
          </div>
        </div>
        {locals.length ? (
          <ol className="assertion-list local-assertion-list">
            {locals.map((assertion, index) => (
              <li key={index} className={derived.stale.has(index) ? "is-stale" : undefined}>
                <StatementText hyps={assertion.if} concl={assertion.then} />
                <span className={`verdict-chip verdict-chip-${assertion.holds ? "provable" : "refuted"}`}>
                  {assertion.holds ? "true" : "false"}
                </span>
                <small>{assertion.note} · {assertion.date}</small>
                <span className={`assertion-state${assertion.submitted ? " is-submitted" : ""}`}>
                  {derived.stale.has(index) ? "no longer needed" : assertion.submitted ? "✓ submitted" : "not submitted"}
                </span>
                <button
                  type="button"
                  className="icon-button"
                  aria-label="Remove this verdict"
                  data-tooltip="Remove"
                  onClick={() => setLocals((current) => current.filter((_, position) => position !== index))}
                >
                  <Trash2 size={15} aria-hidden="true" />
                </button>
              </li>
            ))}
          </ol>
        ) : (
          <p className="assertion-empty">
            <MessageSquarePlus size={15} aria-hidden="true" /> No local verdicts yet. Check an open
            implication above and record whether it holds.
          </p>
        )}
      </section>
    </div>
  );
}

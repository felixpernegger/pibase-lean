import type { DashboardBundle, DashboardData, DirectEdge } from "./types";

export const GRAPH_STATUS = {
  0: { key: "diagonal", label: "Diagonal" },
  1: { key: "explicit-true", label: "True · π-Base theorem" },
  2: { key: "derived-true", label: "True · transitive closure" },
  3: { key: "false", label: "False · unconditional witness" },
  4: { key: "independent", label: "Independent of ZFC" },
  5: { key: "unclassified", label: "Unclassified" },
} as const;

export const FORMAL_GRAPH_STATUS = {
  0: { key: "diagonal", label: "Diagonal" },
  1: { key: "formal-direct", label: "Lean theorem" },
  2: { key: "formal-derived", label: "By transitive closure" },
  3: { key: "unformalized", label: "Not yet formalized" },
  4: { key: "unformalized", label: "Not yet formalized" },
  5: { key: "unformalized", label: "Not yet formalized" },
} as const;

export type GraphStatusCode = keyof typeof GRAPH_STATUS;

function assetUrl(path: string): URL {
  return new URL(path, document.baseURI);
}

export async function loadDashboard(): Promise<DashboardBundle> {
  const response = await fetch(assetUrl("data/dashboard.json"));
  if (!response.ok) throw new Error(`Dashboard data returned ${response.status}`);
  const data = (await response.json()) as DashboardData;
  const [outcomesResponse, formalizedResponse, witnessesResponse] = await Promise.all([
    fetch(assetUrl(data.graph.outcomesPath)),
    fetch(assetUrl(data.graph.formalized.outcomesPath)),
    fetch(assetUrl(data.graph.witnessesPath)),
  ]);
  if (!outcomesResponse.ok || !formalizedResponse.ok || !witnessesResponse.ok) {
    throw new Error("Graph artifacts could not be loaded");
  }
  const outcomes = new Uint8Array(await outcomesResponse.arrayBuffer());
  const formalizedOutcomes = new Uint8Array(await formalizedResponse.arrayBuffer());
  const witnessBytes = await witnessesResponse.arrayBuffer();
  const witnessView = new DataView(witnessBytes);
  const witnesses = new Uint16Array(witnessBytes.byteLength / 2);
  for (let index = 0; index < witnesses.length; index += 1) {
    witnesses[index] = witnessView.getUint16(index * 2, true);
  }
  return { data, outcomes, formalizedOutcomes, witnesses };
}

export function formatNumber(value: number): string {
  return new Intl.NumberFormat("en-GB").format(value);
}

export function formatPercent(value: number, total: number, digits = 1): string {
  if (!total) return "0%";
  return `${((value / total) * 100).toFixed(digits)}%`;
}

export function plainMathLabel(value: string): string {
  return value
    .replace(/\\frac\{1\}\{2\}/g, "½")
    .replace(/\\leq/g, "≤")
    .replace(/\\geq/g, "≥")
    .replace(/\\lt/g, "<")
    .replace(/\\gt/g, ">")
    .replace(/\\sigma/g, "σ")
    .replace(/\\omega/g, "ω")
    .replace(/\\alpha/g, "α")
    .replace(/\\delta/g, "δ")
    .replace(/\\aleph/g, "ℵ")
    .replace(/\\mathbb\s*\{?R\}?/g, "ℝ")
    .replace(/\\mathfrak\s*\{?c\}?/g, "c")
    .replace(/\\(?:mathrm|text)\s*\{([^}]*)\}/g, "$1")
    .replace(/[${}]/g, "")
    .replace(/\\/g, "")
    .replace(/\s+/g, " ")
    .trim();
}

export function shortUid(uid: string): string {
  return `${uid[0]}${Number(uid.slice(1))}`;
}

export function graphIndex(size: number, sourceIndex: number, targetIndex: number): number {
  return sourceIndex * size + targetIndex;
}

export function statusAt(bundle: DashboardBundle, sourceIndex: number, targetIndex: number): GraphStatusCode {
  return bundle.outcomes[graphIndex(bundle.data.graph.size, sourceIndex, targetIndex)] as GraphStatusCode;
}

export function graphStatusLabel(
  data: DashboardData,
  state: GraphStatusCode,
  source?: string,
  target?: string,
): string {
  if (state !== 4 || !source || !target) return GRAPH_STATUS[state].label;
  const dependency = data.graph.axiomDependencies.find(
    (item) => item.source === source && item.target === target,
  );
  return dependency?.baseTheory
    ? `Independent of ${dependency.baseTheory}`
    : GRAPH_STATUS[state].label;
}

export function routeTo(route: string, params?: Record<string, string | number | undefined>): string {
  const query = new URLSearchParams();
  Object.entries(params ?? {}).forEach(([key, value]) => {
    if (value !== undefined && value !== "") query.set(key, String(value));
  });
  return `#/${route}${query.size ? `?${query}` : ""}`;
}

export function parseHash(): { route: string; params: URLSearchParams } {
  const raw = window.location.hash.replace(/^#\/?/, "");
  const [route = "overview", query = ""] = raw.split("?", 2);
  return { route: route || "overview", params: new URLSearchParams(query) };
}

export function downloadText(filename: string, content: string, type = "application/json"): void {
  const blob = new Blob([content], { type });
  const url = URL.createObjectURL(blob);
  const anchor = document.createElement("a");
  anchor.href = url;
  anchor.download = filename;
  anchor.click();
  URL.revokeObjectURL(url);
}

export function findProofPath(
  data: DashboardData,
  source: string,
  target: string,
  edges: DirectEdge[] = data.graph.direct,
): string[] {
  if (source === target) return [source];
  const adjacency = new Map<string, string[]>();
  edges.forEach((edge) => {
    adjacency.set(edge.source, [...(adjacency.get(edge.source) ?? []), edge.target]);
  });
  const queue = [source];
  const previous = new Map<string, string | null>([[source, null]]);
  while (queue.length) {
    const current = queue.shift()!;
    for (const next of adjacency.get(current) ?? []) {
      if (previous.has(next)) continue;
      previous.set(next, current);
      if (next === target) {
        const path = [target];
        let cursor: string | null = current;
        while (cursor) {
          path.push(cursor);
          cursor = previous.get(cursor) ?? null;
        }
        return path.reverse();
      }
      queue.push(next);
    }
  }
  return [];
}

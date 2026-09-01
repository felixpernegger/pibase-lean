export type LeanStatusName =
  | "dependency-clean"
  | "dependency-debt"
  | "local-debt"
  | "missing-declaration";

export interface LeanStatus {
  represented: boolean;
  declarationPresent: boolean;
  dependencyClean: boolean;
  status: LeanStatusName;
  files: number;
  localPlaceholders: number;
  dependencyPlaceholders: number;
  localAxioms: number;
  dependencyAxioms: number;
  wellDefinedPlaceholders: number;
  dependencyWellDefinedPlaceholders: number;
  dependencyNonWellDefinedPlaceholders: number;
  sourcePath: string;
}

export type SpaceAuditStatus =
  | "implemented"
  | "not-implemented"
  | "invalid"
  | "not-targeted";

export type TargetedSpaceAuditStatus = Exclude<SpaceAuditStatus, "not-targeted">;

export interface SpaceAuditFailure {
  code: string;
  message: string;
}

export interface SpaceAuditAssumptions {
  expected: string[];
  declared: string[];
  used: string[];
  valid: boolean;
}

export interface SpaceAuditAxioms {
  axioms: string[];
  trusted: string[];
  conditional: string[];
  forbidden: string[];
}

export interface SpaceAuditPresentation {
  carrier: string | null;
  canonicalHomeomorph: string | null;
  typeValid: boolean;
  assumptions: SpaceAuditAssumptions;
  axioms: SpaceAuditAxioms;
  failures: SpaceAuditFailure[];
  status: TargetedSpaceAuditStatus;
}

export interface SpaceAuditTrait {
  propertyId: string;
  name: string | null;
  expected: boolean;
  polarity: boolean;
  certificate: string | null;
  provenance: "direct" | "derived" | null;
  typeValid: boolean;
  assumptions: SpaceAuditAssumptions;
  axioms: SpaceAuditAxioms;
  failures: SpaceAuditFailure[];
  status: TargetedSpaceAuditStatus;
}

export interface TargetedSpaceAudit {
  targeted: true;
  spaceId: string;
  catalogName: string | null;
  presentation: SpaceAuditPresentation;
  traits: SpaceAuditTrait[];
  failures: SpaceAuditFailure[];
  status: TargetedSpaceAuditStatus;
}

export interface NonTargetedSpaceAudit {
  targeted: false;
  status: "not-targeted";
}

export type SpaceAudit = TargetedSpaceAudit | NonTargetedSpaceAudit;

export interface PropertyNode {
  id: string;
  shortId: string;
  name: string;
  aliases: string[];
  description: string;
  lean: LeanStatus | null;
  registry: { class: string; tier: string; note?: string } | null;
  referenceUrl: string;
}

export interface SpaceNode {
  id: string;
  shortId: string;
  name: string;
  referenceUrl: string;
  lean: LeanStatus | null;
  spaceAudit: SpaceAudit;
  assumptions: string[];
}

export interface FrontierItem {
  source: string;
  target: string;
  closureGain: number;
  sourceAncestors: number;
  targetDescendants: number;
  conditionalEvidence?: boolean;
  axioms?: string[];
  pibaseStatus?: "direct" | "derived";
}

export interface AxiomDependency {
  source: string;
  target: string;
  baseTheory: string;
  axioms: string[];
  trueWhen: string;
  falseWhen: string;
  summary: string;
  theorems: string[];
  referenceUrl: string;
}

export interface ConditionalWitness {
  space: string;
  assumptions: string[];
  condition: string;
  summary: string;
  referenceUrl: string;
}

export interface ConditionalEvidence {
  source: string;
  target: string;
  witnesses: ConditionalWitness[];
}

export interface DirectEdge {
  source: string;
  target: string;
  theorems: string[];
}

export interface DashboardData {
  schemaVersion: 5;
  project: {
    id: string;
    name: string;
    domain: string;
    repoUrl: string;
    repositoryLabel: string;
    referenceUrl: string;
  };
  source: {
    commit: string;
    commitShort: string;
    branch: string;
    sourceDate: string;
    generatedAt: string;
    dataSha: string;
  };
  summary: {
    propertyEntries: number;
    propertyImplementations: number;
    propertyTotal: number;
    mappedProperties: number;
    theoremEntries: number;
    theoremTotal: number;
    theoremImplementations: number;
    dependencyCleanTheorems: number;
    spaceEntries: number;
    spaceImplementations: number;
    spaceTotal: number;
    resolvedPairs: number;
    totalPairs: number;
    unclassifiedPairs: number;
  };
  trust: {
    properties: Record<LeanStatusName, number>;
    theorems: Record<LeanStatusName, number>;
    spaces: Record<LeanStatusName, number>;
    projectPlaceholders: number;
    projectAxioms: number;
  };
  graph: {
    size: number;
    counts: Record<string, number>;
    outcomesPath: string;
    witnessesPath: string;
    statusCodes: Record<string, string>;
    direct: DirectEdge[];
    witnessCounts: Record<string, number>;
    axiomDependencies: AxiomDependency[];
    conditionalEvidence: ConditionalEvidence[];
    formalized: {
      counts: Record<string, number>;
      outcomesPath: string;
      direct: DirectEdge[];
      frontier: FrontierItem[];
    };
  };
  properties: PropertyNode[];
  spaces: SpaceNode[];
  frontier: FrontierItem[];
  recentActivity: Array<{
    sha: string;
    short: string;
    date: string;
    subject: string;
  }>;
  latestDelta: Record<string, number>;
  downloads: Array<{ label: string; path: string; format: string }>;
}

export interface DashboardBundle {
  data: DashboardData;
  outcomes: Uint8Array;
  formalizedOutcomes: Uint8Array;
  witnesses: Uint16Array;
}

export interface ImplicationAtom {
  uid: string;
  value: boolean;
  name: string;
}

export interface ImplicationPair {
  if: ImplicationAtom | ImplicationAtom[];
  then: ImplicationAtom;
}

export interface AcceptedAssertion extends ImplicationPair {
  holds: boolean;
  note: string;
  date: string;
}

export type ImplicationModelMeta =
  | { kind: "space"; uid: string; name: string }
  | { kind: "assertion"; index: number };

// The payload produced by felixpernegger/pibase-data's build_site.py; see
// dashboard/src/engine.ts for the literal encoding conventions.
export interface ImplicationsData {
  repo: string;
  generated: string;
  counts: { total: number; refuted: number; provable: number; unknown: number };
  spaces: number;
  assertions: AcceptedAssertion[];
  pairs: ImplicationPair[];
  prop_ids: string[];
  prop_names: string[];
  clauses: number[][];
  clause_ids: string[];
  models: string[];
  model_meta: ImplicationModelMeta[];
  new_true: ImplicationPair[];
}

export interface LocalAssertion {
  if: ImplicationAtom[];
  then: ImplicationAtom;
  holds: boolean;
  note: string;
  date: string;
  submitted: boolean;
}

export type ReviewKind = "spaces" | "properties" | "theorems";

export interface ReviewTrait {
  property: string;
  name: string;
  value: boolean;
  status: "asserted" | "proven" | "derivable";
  via: string | null;
}

interface ReviewEntryBase {
  id: string;
  shortId: string;
  name: string;
  aliases: string[];
  description: string;
  author: string;
  sourcePath: string;
  sourceUrl: string;
  referenceUrl: string;
  code: string;
  extraCode: string;
  leanStatus: LeanStatus;
}

export interface StandardReviewEntry extends ReviewEntryBase {
  spaceAudit?: never;
  traits?: never;
  traitSummary?: never;
}

export interface SpaceReviewEntry extends ReviewEntryBase {
  generatedCode: string;
  spaceAudit: SpaceAudit;
  traits: ReviewTrait[];
  traitSummary: Partial<Record<ReviewTrait["status"], number>>;
}

export type ReviewEntry = StandardReviewEntry | SpaceReviewEntry;

interface ReviewEntrySummaryBase {
  id: string;
  shortId: string;
  name: string;
  aliases: string[];
  author: string;
  sourceUrl: string;
  referenceUrl: string;
  leanStatus: LeanStatus;
  chunk: number;
}

export interface StandardReviewEntrySummary extends ReviewEntrySummaryBase {
  spaceAudit?: never;
}

export interface SpaceReviewEntrySummary extends ReviewEntrySummaryBase {
  spaceAudit: SpaceAudit;
}

export type ReviewEntrySummary = StandardReviewEntrySummary | SpaceReviewEntrySummary;

interface ReviewPayloadBase {
  schemaVersion: 2;
  sourceCommit: string;
  generatedAt: string;
  chunkSize: number;
  chunks: string[];
}

export type ReviewPayload =
  | (ReviewPayloadBase & { kind: "spaces"; entries: SpaceReviewEntrySummary[] })
  | (ReviewPayloadBase & { kind: "properties" | "theorems"; entries: StandardReviewEntrySummary[] });

interface ReviewChunkPayloadBase {
  schemaVersion: 2;
  chunk: number;
  sourceCommit: string;
}

export type ReviewChunkPayload =
  | (ReviewChunkPayloadBase & { kind: "spaces"; entries: SpaceReviewEntry[] })
  | (ReviewChunkPayloadBase & { kind: "properties" | "theorems"; entries: StandardReviewEntry[] });

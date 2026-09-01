import type { ReviewChunkPayload, ReviewKind, ReviewPayload } from "./types";

export const REVIEW_SCHEMA_VERSION = 2;

function isRecord(value: unknown): value is Record<string, unknown> {
  return value !== null && typeof value === "object" && !Array.isArray(value);
}

function payloadError(label: string, message: string): Error {
  return new Error(`${label} ${message}`);
}

export function assertReviewPayload(
  value: unknown,
  kind: ReviewKind,
  sourceCommit: string,
): asserts value is ReviewPayload {
  if (!isRecord(value)) throw payloadError("Review index", "is not an object");
  if (value.schemaVersion !== REVIEW_SCHEMA_VERSION) {
    throw payloadError("Review index", `has unsupported schema ${String(value.schemaVersion)}`);
  }
  if (value.kind !== kind) throw payloadError("Review index", `does not match ${kind}`);
  if (value.sourceCommit !== sourceCommit) {
    throw payloadError("Review index", "does not match the dashboard source commit");
  }
  if (!Array.isArray(value.chunks) || !value.chunks.every((item) => typeof item === "string")) {
    throw payloadError("Review index", "has an invalid chunk list");
  }
  if (!Array.isArray(value.entries)) throw payloadError("Review index", "has invalid entries");
}

export function assertReviewChunkPayload(
  value: unknown,
  kind: ReviewKind,
  chunk: number,
  sourceCommit: string,
): asserts value is ReviewChunkPayload {
  if (!isRecord(value)) throw payloadError("Review chunk", "is not an object");
  if (value.schemaVersion !== REVIEW_SCHEMA_VERSION) {
    throw payloadError("Review chunk", `has unsupported schema ${String(value.schemaVersion)}`);
  }
  if (value.kind !== kind || value.chunk !== chunk) {
    throw payloadError(`Review chunk ${chunk}`, `does not match ${kind}`);
  }
  if (value.sourceCommit !== sourceCommit) {
    throw payloadError(`Review chunk ${chunk}`, "does not match the dashboard source commit");
  }
  if (!Array.isArray(value.entries)) throw payloadError(`Review chunk ${chunk}`, "has invalid entries");
}

export function reviewCacheKey(sourceCommit: string, kind: ReviewKind): string {
  return `${sourceCommit}:${kind}`;
}

export function reviewChunkCacheKey(
  sourceCommit: string,
  kind: ReviewKind,
  chunk: number,
): string {
  return `${reviewCacheKey(sourceCommit, kind)}:${chunk}`;
}

export function versionedReviewUrl(
  path: string,
  sourceCommit: string,
  base: string | URL = document.baseURI,
): URL {
  const baseUrl = new URL(base);
  const dataRoot = new URL("data/", baseUrl);
  const url = new URL(path, baseUrl);
  if (url.origin !== dataRoot.origin || !url.pathname.startsWith(dataRoot.pathname)) {
    throw new Error(`Review data path is outside the dashboard data directory: ${path}`);
  }
  url.searchParams.set("v", sourceCommit);
  return url;
}

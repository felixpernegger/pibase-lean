import assert from "node:assert/strict";
import test from "node:test";

import { renderSafeMarkdown, safeLinkHref } from "../dashboard/src/safeMarkdown.ts";
import {
  assertReviewChunkPayload,
  assertReviewPayload,
  reviewCacheKey,
  reviewChunkCacheKey,
  versionedReviewUrl,
} from "../dashboard/src/reviewData.ts";

const COMMIT_A = "a".repeat(40);
const COMMIT_B = "b".repeat(40);

test("safe Markdown drops raw HTML and unsafe links", () => {
  const html = renderSafeMarkdown(
    '<img src=x onerror="alert(1)"> [unsafe](javascript:alert(1)) [safe](https://example.com)',
    true,
  );
  assert.doesNotMatch(html, /img|onerror|javascript:/i);
  assert.match(html, /<a href="https:\/\/example\.com">safe<\/a>/);
  assert.equal(safeLinkHref("javascript:alert(1)"), null);
  assert.equal(safeLinkHref("data:text/html,pwned"), null);
  assert.equal(safeLinkHref("mailto:reviewer@example.com"), "mailto:reviewer@example.com");
  assert.doesNotMatch(renderSafeMarkdown("visible<!-- hidden catalog note -->", true), /hidden/);
  assert.equal(renderSafeMarkdown("**still formatted**", true), "<strong>still formatted</strong>");
});

test("review payload validation rejects stale commits and schemas", () => {
  const index = {
    schemaVersion: 2,
    kind: "spaces",
    sourceCommit: COMMIT_A,
    chunks: ["data/review-spaces-000.json"],
    entries: [],
  };
  assert.doesNotThrow(() => assertReviewPayload(index, "spaces", COMMIT_A));
  assert.throws(() => assertReviewPayload(index, "spaces", COMMIT_B), /source commit/);
  assert.throws(
    () => assertReviewPayload({ ...index, schemaVersion: 1 }, "spaces", COMMIT_A),
    /unsupported schema/,
  );

  const chunk = {
    schemaVersion: 2,
    kind: "spaces",
    chunk: 0,
    sourceCommit: COMMIT_A,
    entries: [],
  };
  assert.doesNotThrow(() => assertReviewChunkPayload(chunk, "spaces", 0, COMMIT_A));
  assert.throws(() => assertReviewChunkPayload(chunk, "spaces", 0, COMMIT_B), /source commit/);
});

test("review caches and URLs are scoped to the source commit", () => {
  assert.notEqual(reviewCacheKey(COMMIT_A, "spaces"), reviewCacheKey(COMMIT_B, "spaces"));
  assert.notEqual(
    reviewChunkCacheKey(COMMIT_A, "spaces", 0),
    reviewChunkCacheKey(COMMIT_B, "spaces", 0),
  );
  const url = versionedReviewUrl(
    "data/review-spaces-000.json",
    COMMIT_A,
    "https://example.com/pibase-lean/",
  );
  assert.equal(url.pathname, "/pibase-lean/data/review-spaces-000.json");
  assert.equal(url.searchParams.get("v"), COMMIT_A);
  assert.throws(
    () => versionedReviewUrl("https://attacker.invalid/chunk.json", COMMIT_A, "https://example.com/"),
    /outside the dashboard data directory/,
  );
});

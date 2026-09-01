module

public meta import PiBaseLean.Audit.Spaces.Audit
public import PiBaseLean.Spaces.S1.Generated
public import PiBaseLean.Spaces.S4.Generated
public import PiBaseLean.Spaces.S10.Generated
public import PiBaseLean.Spaces.S189.Generated

@[expose] public meta section

open Lean
open PiBase.Audit.Spaces

namespace PiBase.Audit.Spaces.Tests

def testReport (summary : AuditSummary) (failures : Array AuditFailure := #[]) : AuditReport :=
  { schemaVersion := spaceAuditSchemaVersion
    scope := expectedSpaceIds
    catalogSchemaVersion := generatedCatalog.schemaVersion
    sourceHashes := generatedCatalog.sourceHashes
    summary
    spaces := #[]
    failures }

def incompleteReport : AuditReport := testReport {
  spaces := expectedSpaceIds.size
  implemented := 0
  notImplemented := expectedSpaceIds.size
  invalid := 0
  traits := 0
  failures := expectedSpaceIds.size
}

run_cmd do
  let implementedReport := testReport {
    spaces := expectedSpaceIds.size
    implemented := expectedSpaceIds.size
    notImplemented := 0
    invalid := 0
    traits := 0
    failures := 0
  }
  unless implementedReport.status == .implemented do
    throwError "a complete audit report was not classified as implemented"
  unless incompleteReport.status == .notImplemented do
    throwError "an incomplete-only audit report was not classified as not implemented"
  let expectedSummary :=
    s!"Pi-Base space audit: not-implemented\n\
      spaces: {expectedSpaceIds.size}, implemented: 0, \
      not implemented: {expectedSpaceIds.size}, invalid: 0\n\
      traits: 0, failures: {expectedSpaceIds.size}"
  unless incompleteReport.summaryString == expectedSummary do
    throwError "incomplete audit summary has the wrong status label:\n\
      {incompleteReport.summaryString}"
  let invalidCountReport := testReport {
    incompleteReport.summary with invalid := 1
  }
  unless invalidCountReport.status == .invalid do
    throwError "an audit report with invalid spaces was not classified as invalid"
  let topLevelFailureReport := testReport incompleteReport.summary
    #[failure "test-failure" "test top-level failure"]
  unless topLevelFailureReport.status == .invalid do
    throwError "an audit report with a top-level failure was not classified as invalid"
  let inconsistentReport := testReport {
    spaces := expectedSpaceIds.size
    implemented := 0
    notImplemented := 0
    invalid := 0
    traits := 0
    failures := 0
  }
  unless inconsistentReport.status == .invalid do
    throwError "an internally inconsistent audit report did not fail closed"

end PiBase.Audit.Spaces.Tests

run_cmd do
  let syntheticForbidden := `PiBase.Audit.Spaces.Tests.syntheticForbiddenAxiom
  let classified := classifyAxioms #[syntheticForbidden]
  unless classified.axioms == #[syntheticForbidden] && classified.trusted.isEmpty &&
      classified.conditional.isEmpty && classified.forbidden == #[syntheticForbidden] do
    throwError "unknown axioms must be classified as forbidden: {repr classified}"
  let report ← Lean.Elab.Command.liftTermElabM buildAuditReport
  unless report.isSuccess do
    throwError "space audit unexpectedly failed:\n{report.toJson.pretty}"
  unless report.summary.spaces == 4 && report.summary.implemented == 4 do
    throwError "unexpected implemented-space summary: {repr report.summary}"
  unless report.summary.traits == 86 do
    throwError "unexpected total trait count: {report.summary.traits}"
  let expectedDirectCounts := #[
    ("S000001", 3),
    ("S000004", 3),
    ("S000010", 5),
    ("S000189", 3)
  ]
  for (spaceId, expectedCount) in expectedDirectCounts do
    let actualCount := match expectedCatalogMatches spaceId with
      | #[space] => space.directTraits.size
      | _ => 0
    unless actualCount == expectedCount do
      throwError "unexpected direct trait count for {spaceId}: {actualCount}"
  if let .error message := Json.parse report.toJsonString then
    throwError "audit JSON did not parse: {message}"

set_option linter.hashCommand false in
#assert_pibase_spaces

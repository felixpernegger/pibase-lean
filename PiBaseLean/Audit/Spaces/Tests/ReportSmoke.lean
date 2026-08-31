module

public meta import PiBaseLean.Audit.Spaces.Audit

@[expose] public meta section

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

module

public meta import PiBaseLean.Audit.Spaces.Audit
public meta import PiBaseLean.Audit.Spaces.Tests.RegistrySmoke
public meta import PiBaseLean.Audit.Spaces.Tests.DuplicateDiamondLeft
public meta import PiBaseLean.Audit.Spaces.Tests.DuplicateDiamondRight
public meta import PiBaseLean.Audit.Spaces.Tests.DuplicateIndependent

@[expose] public meta section

open Lean
open PiBase.Audit.Spaces

def duplicateSpaceId := "TEST-CROSS-MODULE-DUPLICATE"

namespace PiBase.Audit.Spaces.Tests

/-- Test-only unsupported axiom used to exercise transitive axiom classification. -/
axiom spaceAuditForbiddenAxiomFixture : True

theorem spaceAuditForbiddenAxiomConsumer : True :=
  spaceAuditForbiddenAxiomFixture

end PiBase.Audit.Spaces.Tests

run_cmd do
  let env ← getEnv
  let spaces := (getSpaceRegistrations env).filter (·.spaceId == duplicateSpaceId)
  unless spaces.size == 2 do
    throwError
      "expected one diamond-imported and one independent space registration; found {spaces.size}"
  let certificates := (getCertificateRegistrations env).filter fun entry =>
    entry.spaceId == duplicateSpaceId && entry.propertyId == "P000001"
  unless certificates.size == 2 do
    throwError
      "expected one diamond-imported and one independent certificate registration; found \
        {certificates.size}"
  let report ← Lean.Elab.Command.liftTermElabM buildAuditReport
  let registrySmoke ← match report.spaces.find? (·.spaceId == "S000001") with
    | some audit => pure audit
    | none => throwError "audit report omitted S000001"
  unless registrySmoke.presentation.typeValid &&
      registrySmoke.presentation.status == .implemented do
    throwError
      "later topology instance invalidated S000001 presentation: {repr registrySmoke.presentation}"
  let forbiddenResult ← Lean.Elab.Command.liftTermElabM <|
    collectAxiomAudit ``PiBase.Audit.Spaces.Tests.spaceAuditForbiddenAxiomConsumer
  let forbiddenAudit ← match forbiddenResult with
    | .ok audit => pure audit
    | .error message => throwError "failed to collect test fixture axioms: {message}"
  unless forbiddenAudit.forbidden.contains
      ``PiBase.Audit.Spaces.Tests.spaceAuditForbiddenAxiomFixture do
    throwError "audit did not classify the test-only axiom as forbidden: {repr forbiddenAudit}"
  unless (axiomFailures "test fixture" forbiddenAudit).any (·.code == "forbidden-axiom") do
    throwError "audit did not emit a forbidden-axiom failure for the test fixture"
  unless report.failures.any (·.code == "duplicate-space-registration") do
    throwError "audit did not report the cross-module space duplicate"
  unless report.failures.any (·.code == "duplicate-certificate-registration") do
    throwError "audit did not report the cross-module certificate duplicate"
  unless report.failures.any (·.code == "duplicate-proof-registration") do
    throwError "audit did not report the cross-module proof duplicate"
  unless report.failures.any (·.code == "duplicate-space-carrier") do
    throwError "audit did not report a carrier shared by distinct space IDs"
  unless report.failures.any (·.code == "duplicate-canonical-homeomorph") do
    throwError "audit did not report a canonical homeomorphism shared by distinct space IDs"

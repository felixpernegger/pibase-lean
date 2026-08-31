module

public meta import PiBaseLean.Audit.Spaces.Expected
public meta import PiBaseLean.Audit.Spaces.Registry

@[expose] public meta section

namespace PiBase.Audit.Spaces

open Lean

/-- Stable implementation states used by the human-readable and JSON reports. -/
inductive AuditStatus where
  | implemented
  | notImplemented
  | invalid
  deriving Repr, Inhabited, DecidableEq

/-- A stable machine-readable failure code with a human-readable explanation. -/
structure AuditFailure where
  code : String
  message : String
  deriving Repr, Inhabited, DecidableEq

/-- Exact comparison of catalog, registration, and axiom-derived assumptions. -/
structure AssumptionAudit where
  expected : Array AssumptionId
  declared : Array AssumptionId
  used : Array AssumptionId
  valid : Bool
  deriving Repr, Inhabited, DecidableEq

/-- Classification of every transitive axiom used by one declaration. -/
structure AxiomAudit where
  axioms : Array Name
  trusted : Array Name
  conditional : Array Name
  forbidden : Array Name
  deriving Repr, Inhabited, DecidableEq

/-- Validation of a space carrier and its canonical presentation. -/
structure PresentationAudit where
  «carrier» : Option Name
  canonicalHomeomorph : Option Name
  typeValid : Bool
  «assumptions» : AssumptionAudit
  axioms : AxiomAudit
  failures : Array AuditFailure
  status : AuditStatus
  deriving Repr, Inhabited

/-- Validation of one direct catalog obligation or registered derived certificate. -/
structure TraitAudit where
  propertyId : String
  propertyName : Option String
  expected : Bool
  polarity : Bool
  certificate : Option Name
  «provenance» : Option CertificateProvenance
  typeValid : Bool
  «assumptions» : AssumptionAudit
  axioms : AxiomAudit
  failures : Array AuditFailure
  status : AuditStatus
  deriving Repr, Inhabited

/-- Complete validation result for one explicitly scoped catalog space. -/
structure SpaceAudit where
  spaceId : String
  catalogName : Option String
  presentation : PresentationAudit
  traits : Array TraitAudit
  failures : Array AuditFailure
  status : AuditStatus
  deriving Repr, Inhabited

/-- Deterministic counts summarizing the audited scope. -/
structure AuditSummary where
  spaces : Nat
  implemented : Nat
  notImplemented : Nat
  invalid : Nat
  traits : Nat
  failures : Nat
  deriving Repr, Inhabited

/-- The complete schema-v1 space audit report. -/
structure AuditReport where
  schemaVersion : Nat
  scope : Array String
  catalogSchemaVersion : Nat
  sourceHashes : SourceHashes
  summary : AuditSummary
  spaces : Array SpaceAudit
  failures : Array AuditFailure
  deriving Repr

def emptyAssumptionAudit : AssumptionAudit :=
  { expected := #[], declared := #[], used := #[], valid := true }

def emptyAxiomAudit : AxiomAudit :=
  { axioms := #[], trusted := #[], conditional := #[], forbidden := #[] }

def failure (code message : String) : AuditFailure := { code, message }

def statusString : AuditStatus → String
  | .implemented => "implemented"
  | .notImplemented => "not-implemented"
  | .invalid => "invalid"

def provenanceString : CertificateProvenance → String
  | .direct => "direct"
  | .derived => "derived"

def assumptionString : AssumptionId → String
  | .continuumHypothesis => "continuum-hypothesis"
  | .notContinuumHypothesis => "not-continuum-hypothesis"
  | .martinsAxiom => "martins-axiom"
  | .generalizedContinuumHypothesis => "generalized-continuum-hypothesis"

def nameLess (lhs rhs : Name) : Bool := lhs.toString < rhs.toString

def stringLess (lhs rhs : String) : Bool := lhs < rhs

def sortNames (names : Array Name) : Array Name := names.qsort nameLess

def sortFailures (failures : Array AuditFailure) : Array AuditFailure :=
  failures.qsort fun lhs rhs =>
    lhs.code < rhs.code || (lhs.code == rhs.code && lhs.message < rhs.message)

def trustedAxioms : Array Name := #[``propext, ``Classical.choice, ``Quot.sound]

/-- Conditional axiom declarations recognized by schema v1. Initially empty by design. -/
def conditionalAxiomMappings : Array (Name × AssumptionId) := #[]

def assumptionForAxiom? (axiomName : Name) : Option AssumptionId :=
  (conditionalAxiomMappings.find? (·.1 == axiomName)).map (·.2)

def classifyAxioms (axioms : Array Name) : AxiomAudit :=
  let axioms := sortNames axioms
  { axioms
    trusted := axioms.filter trustedAxioms.contains
    conditional := axioms.filter (assumptionForAxiom? · |>.isSome)
    forbidden := axioms.filter fun axiomName =>
      !trustedAxioms.contains axiomName && (assumptionForAxiom? axiomName).isNone }

def usedAssumptions (axioms : AxiomAudit) : Array AssumptionId :=
  axioms.conditional.filterMap assumptionForAxiom?

def auditAssumptions
    (expected declared : Array AssumptionId) (axioms : AxiomAudit) : AssumptionAudit :=
  let used := usedAssumptions axioms
  { expected, declared, used, valid := expected == declared && declared == used }

def emptyPresentation (failures : Array AuditFailure) : PresentationAudit :=
  { «carrier» := none
    canonicalHomeomorph := none
    typeValid := false
    «assumptions» := emptyAssumptionAudit
    axioms := emptyAxiomAudit
    failures := sortFailures failures
    status := .notImplemented }

def exceptionString (exception : Exception) : CoreM String := do
  return (← exception.toMessageData.format).pretty

def captureValidation (action : MetaM Unit) : MetaM (Except String Unit) :=
  try
    action
    return .ok ()
  catch exception =>
    return .error (← exceptionString exception)

def collectAxiomAudit (declName : Name) : MetaM (Except String AxiomAudit) :=
  try
    return .ok <| classifyAxioms (← PiBase.Audit.Meta.collectAxioms declName)
  catch exception =>
    return .error (← exceptionString exception)

def axiomFailures (description : String) (audit : AxiomAudit) : Array AuditFailure :=
  audit.forbidden.map fun axiomName =>
    failure "forbidden-axiom" s!"{description} uses forbidden or unmapped axiom {axiomName}"

def assumptionFailures
    (description : String) (audit : AssumptionAudit) : Array AuditFailure := Id.run do
  let mut failures := #[]
  unless audit.expected == audit.declared do
    failures := failures.push <| failure "assumption-declaration-mismatch"
      s!"{description} declares {repr audit.declared}; expected {repr audit.expected}"
  unless audit.declared == audit.used do
    failures := failures.push <| failure "assumption-usage-mismatch"
      s!"{description} uses {repr audit.used}; declared {repr audit.declared}"
  return failures

def statusFromIssues
    (invalidFailures incompleteFailures : Array AuditFailure) : AuditStatus :=
  if !invalidFailures.isEmpty then .invalid
  else if !incompleteFailures.isEmpty then .notImplemented
  else .implemented

inductive SpaceContext where
  | available (registration : SpaceRegistration)
  | missing
  | conflicting (count : Nat)

structure PropertyResolution where
  name : Option String
  decl : Option Name
  formalized : Bool
  invalidFailures : Array AuditFailure
  incompleteFailures : Array AuditFailure

def spaceContext (registrations : Array SpaceRegistration) : SpaceContext :=
  match registrations with
  | #[registration] => .available registration
  | #[] => .missing
  | registrations => .conflicting registrations.size

def resolveProperty (env : Environment) (propertyId : String) : PropertyResolution :=
  let (propertyName, catalogFailures) :=
    match expectedPropertyMatches propertyId with
    | #[property] => (some property.name, #[])
    | #[] =>
        (none, #[failure "unknown-catalog-property"
          s!"no catalog property exists for {propertyId}"])
    | properties =>
        (none, #[failure "duplicate-catalog-property"
          s!"catalog property {propertyId} occurs {properties.size} times"])
  match propertyDeclName propertyId with
  | .error message =>
      { name := propertyName
        decl := none
        formalized := false
        invalidFailures := catalogFailures.push <| failure "invalid-property-id" message
        incompleteFailures := #[] }
  | .ok decl =>
      if env.contains decl then
        { name := propertyName
          decl := some decl
          formalized := true
          invalidFailures := catalogFailures
          incompleteFailures := #[] }
      else
        { name := propertyName
          decl := some decl
          formalized := false
          invalidFailures := catalogFailures
          incompleteFailures := #[failure "property-not-formalized"
            s!"property declaration {decl} is not visible for {propertyId}"] }

def auditPresentation
    (space : SpaceEntry) (registrations : Array SpaceRegistration) : MetaM PresentationAudit := do
  match registrations with
  | #[] =>
      return emptyPresentation #[failure "missing-space-registration"
        s!"no space registration is visible for {space.id}"]
  | #[registration] =>
      let mut failures := #[]
      unless registration.catalogName == space.name do
        failures := failures.push <| failure "catalog-name-mismatch"
          s!"{space.id} registers catalog name {registration.catalogName}; expected {space.name}"
      let validation ← captureValidation <|
        validateSpaceDecls registration.carrier registration.canonicalHomeomorph
      let typeValid := validation.isOk
      if let .error message := validation then
        failures := failures.push <| failure "invalid-presentation" message
      let axiomResult ← collectAxiomAudit registration.canonicalHomeomorph
      let axioms ← match axiomResult with
        | .ok audit => pure audit
        | .error message =>
            failures := failures.push <| failure "canonical-axiom-scan-failed" message
            pure emptyAxiomAudit
      failures := failures ++ axiomFailures s!"canonical declaration for {space.id}" axioms
      let assumptionAudit := auditAssumptions
        space.conditionalAssumptions registration.assumptionIds axioms
      failures := failures ++ assumptionFailures s!"space {space.id}" assumptionAudit
      failures := sortFailures failures
      return {
        «carrier» := some registration.carrier
        canonicalHomeomorph := some registration.canonicalHomeomorph
        typeValid
        «assumptions» := assumptionAudit
        axioms
        failures
        status := statusFromIssues failures #[]
      }
  | registrations =>
      return { (emptyPresentation #[failure "conflicting-space-registration"
        s!"expected one space registration for {space.id}; found {registrations.size}"]) with
        status := .invalid }

def unavailableAssumptions (expected : Array AssumptionId) : AssumptionAudit :=
  { expected, declared := #[], used := #[], valid := expected.isEmpty }

def emptyTrait
    (space : SpaceEntry) (propertyId : String) (expected polarity : Bool)
    (resolution : PropertyResolution) (invalid incomplete : Array AuditFailure) : TraitAudit :=
  let invalid := resolution.invalidFailures ++ invalid
  let incomplete := resolution.incompleteFailures ++ incomplete
  { propertyId
    propertyName := resolution.name
    expected
    polarity
    certificate := none
    «provenance» := none
    typeValid := false
    «assumptions» := unavailableAssumptions space.conditionalAssumptions
    axioms := emptyAxiomAudit
    failures := sortFailures (invalid ++ incomplete)
    status := statusFromIssues invalid incomplete }

def auditRegisteredCertificate
    (space : SpaceEntry) (context : SpaceContext) (certificate : CertificateRegistration)
    (expected : Bool) (expectedProvenance : CertificateProvenance)
    (rejectDirectObligation duplicateKey : Bool) : MetaM TraitAudit := do
  let env ← getEnv
  let resolution := resolveProperty env certificate.propertyId
  let mut invalid := resolution.invalidFailures
  let mut incomplete := resolution.incompleteFailures
  if let some expectedProperty := resolution.decl then
    unless certificate.property == expectedProperty do
      invalid := invalid.push <| failure "property-declaration-mismatch"
        s!"{space.id}/{certificate.propertyId} registers {certificate.property}; expected \
          {expectedProperty}"
  unless certificate.polarity == expected do
    invalid := invalid.push <| failure "polarity-mismatch"
      s!"{space.id}/{certificate.propertyId} has polarity {certificate.polarity}; expected \
        {expected}"
  unless certificate.provenance == expectedProvenance do
    invalid := invalid.push <| failure "provenance-mismatch"
      s!"{space.id}/{certificate.propertyId} requires \
        {provenanceString expectedProvenance} provenance"
  if rejectDirectObligation then
    invalid := invalid.push <| failure "derived-direct-obligation"
      s!"{space.id}/{certificate.propertyId} is a direct catalog obligation"
  if duplicateKey then
    invalid := invalid.push <| failure "duplicate-certificate-registration"
      s!"multiple registrations exist for {space.id}/{certificate.propertyId}"
  let mut typeValid := false
  if resolution.formalized then
    match context with
    | .available registration =>
        let validation ← captureValidation <|
          validateCertificateDecls registration certificate.property certificate.proof
            certificate.polarity
        typeValid := validation.isOk
        if let .error message := validation then
          invalid := invalid.push <| failure "invalid-certificate-type" message
    | .missing =>
        incomplete := incomplete.push <| failure "certificate-space-not-registered"
          s!"cannot validate {space.id}/{certificate.propertyId} without a space registration"
    | .conflicting count =>
        invalid := invalid.push <| failure "certificate-space-registration-conflict"
          s!"cannot validate {space.id}/{certificate.propertyId} with {count} space registrations"
  let axiomResult ← collectAxiomAudit certificate.proof
  let mut axioms := emptyAxiomAudit
  match axiomResult with
  | .ok audit => axioms := audit
  | .error message =>
      invalid := invalid.push <| failure "certificate-axiom-scan-failed" message
  invalid := invalid ++ axiomFailures
    s!"certificate {space.id}/{certificate.propertyId}" axioms
  let assumptionAudit := auditAssumptions
    space.conditionalAssumptions certificate.assumptionIds axioms
  invalid := invalid ++ assumptionFailures
    s!"certificate {space.id}/{certificate.propertyId}" assumptionAudit
  return {
    propertyId := certificate.propertyId
    propertyName := resolution.name
    expected
    polarity := certificate.polarity
    certificate := some certificate.proof
    «provenance» := some certificate.provenance
    typeValid
    «assumptions» := assumptionAudit
    axioms
    failures := sortFailures (invalid ++ incomplete)
    status := statusFromIssues invalid incomplete
  }

def auditDirectObligation
    (env : Environment) (space : SpaceEntry) (context : SpaceContext)
    (certificates : Array CertificateRegistration) (obligation : TraitObligation) :
    MetaM TraitAudit := do
  let resolution := resolveProperty env obligation.propertyId
  let certificateMatches := certificates.filter fun certificate =>
    certificate.spaceId == space.id && certificate.propertyId == obligation.propertyId
  match certificateMatches with
  | #[] =>
      if resolution.formalized then
        return emptyTrait
          space obligation.propertyId obligation.value obligation.value resolution #[]
          #[failure "missing-certificate"
            s!"no direct certificate is visible for {space.id}/{obligation.propertyId}"]
      else
        return emptyTrait
          space obligation.propertyId obligation.value obligation.value resolution #[] #[]
  | #[certificate] =>
      auditRegisteredCertificate space context certificate obligation.value .direct false false
  | registrations =>
      return emptyTrait space obligation.propertyId obligation.value obligation.value resolution
        #[failure "conflicting-certificate-registration"
          s!"expected one certificate for {space.id}/{obligation.propertyId}; found \
            {registrations.size}"]
        #[]

def traitLess (lhs rhs : TraitAudit) : Bool :=
  lhs.propertyId < rhs.propertyId

def certificateLess
    (lhs rhs : CertificateRegistration) : Bool :=
  lhs.propertyId < rhs.propertyId ||
    (lhs.propertyId == rhs.propertyId && lhs.proof.toString < rhs.proof.toString)

def duplicateStrings (values : Array String) : Array String :=
  let unique := values.foldl (init := #[]) fun result value =>
    if result.contains value then result else result.push value
  unique.filter (fun value => values.count value > 1) |>.qsort (· < ·)

def duplicateNames (values : Array Name) : Array Name :=
  let unique := values.foldl (init := #[]) fun result value =>
    if result.contains value then result else result.push value
  unique.filter (fun value => values.count value > 1) |>.qsort nameLess

def directPropertyIds (space : SpaceEntry) : Array String :=
  space.directTraits.map (·.propertyId)

def auditExpectedSpace
    (env : Environment) (certificates : Array CertificateRegistration)
    (spaceId : String) : MetaM SpaceAudit := do
  match expectedCatalogMatches spaceId with
  | #[] =>
      let failures := #[failure "missing-catalog-space"
        s!"expected space {spaceId} is absent from the generated catalog"]
      return {
        spaceId
        catalogName := none
        presentation := emptyPresentation #[]
        traits := #[]
        failures
        status := .invalid
      }
  | #[space] =>
      let registrations := findSpacesById env spaceId
      let presentation ← auditPresentation space registrations
      let context := spaceContext registrations
      let directObligations := space.directTraits.qsort fun lhs rhs =>
        lhs.propertyId < rhs.propertyId
      let directTraits ← directObligations.mapM <|
        auditDirectObligation env space context certificates
      let directIds := directPropertyIds space
      let supplemental := certificates.filter fun certificate =>
        certificate.spaceId == spaceId &&
          (certificate.provenance == .derived || !directIds.contains certificate.propertyId)
      let supplemental := supplemental.qsort certificateLess
      let derivedTraits ← supplemental.mapM fun certificate =>
        let matching := certificates.filter fun other =>
          other.spaceId == certificate.spaceId && other.propertyId == certificate.propertyId
        auditRegisteredCertificate space context certificate certificate.polarity .derived
          (directIds.contains certificate.propertyId) (matching.size > 1)
      let traits := directTraits.qsort traitLess ++ derivedTraits
      let mut failures := #[]
      for propertyId in duplicateStrings directIds do
        failures := failures.push <| failure "duplicate-direct-obligation"
          s!"catalog space {spaceId} has multiple direct obligations for {propertyId}"
      failures := sortFailures failures
      let childInvalid := presentation.status == .invalid ||
        traits.any (·.status == .invalid)
      let childIncomplete := presentation.status == .notImplemented ||
        traits.any (·.status == .notImplemented)
      let status := if !failures.isEmpty || childInvalid then .invalid
        else if childIncomplete then .notImplemented
        else .implemented
      return {
        spaceId
        catalogName := some space.name
        presentation
        traits
        failures
        status
      }
  | catalogMatches =>
      let failures := #[failure "duplicate-catalog-space"
        s!"expected space {spaceId} occurs {catalogMatches.size} times in the generated catalog"]
      return {
        spaceId
        catalogName := none
        presentation := emptyPresentation #[]
        traits := #[]
        failures
        status := .invalid
      }

def topLevelFailures
    (spaces : Array SpaceRegistration) (certificates : Array CertificateRegistration) :
    Array AuditFailure := Id.run do
  let mut failures := #[]
  unless generatedCatalog.schemaVersion == supportedCatalogSchemaVersion do
    failures := failures.push <| failure "catalog-schema-mismatch"
      s!"catalog schema is {generatedCatalog.schemaVersion}; supported version is \
        {supportedCatalogSchemaVersion}"
  for spaceId in duplicateStrings expectedSpaceIds do
    failures := failures.push <| failure "duplicate-expected-space-id"
      s!"expected scope contains {spaceId} more than once"
  for spaceId in duplicateStrings (spaces.map (·.spaceId)) do
    failures := failures.push <| failure "duplicate-space-registration"
      s!"multiple space registrations exist for {spaceId}"
  for carrierName in duplicateNames (spaces.map (·.carrier)) do
    let registrations := spaces.filter (·.carrier == carrierName)
    if registrations.any fun lhs =>
        registrations.any fun rhs => lhs.spaceId != rhs.spaceId then
      failures := failures.push <| failure "duplicate-space-carrier"
        s!"carrier {carrierName} is registered under multiple space IDs"
  for canonicalName in duplicateNames (spaces.map (·.canonicalHomeomorph)) do
    let registrations := spaces.filter (·.canonicalHomeomorph == canonicalName)
    if registrations.any fun lhs =>
        registrations.any fun rhs => lhs.spaceId != rhs.spaceId then
      failures := failures.push <| failure "duplicate-canonical-homeomorph"
        s!"canonical homeomorphism {canonicalName} is registered under multiple space IDs"
  for registration in spaces do
    unless expectedSpaceIds.contains registration.spaceId do
      failures := failures.push <| failure "unexpected-space-registration"
        s!"space registration {registration.spaceId} is outside the audited scope"
  let certificateKeys := certificates.map fun certificate =>
    certificate.spaceId ++ "/" ++ certificate.propertyId
  for key in duplicateStrings certificateKeys do
    failures := failures.push <| failure "duplicate-certificate-registration"
      s!"multiple certificate registrations exist for {key}"
  for proofName in duplicateNames (certificates.map (·.proof)) do
    failures := failures.push <| failure "duplicate-proof-registration"
      s!"proof {proofName} is used by multiple certificate registrations"
  for certificate in certificates do
    unless expectedSpaceIds.contains certificate.spaceId do
      let known := !(generatedCatalog.spaces.filter
        (·.id == certificate.spaceId)).isEmpty
      let code := if known then "certificate-outside-scope" else "certificate-unknown-space"
      failures := failures.push <| failure code
        s!"certificate {certificate.spaceId}/{certificate.propertyId} is not for a target space"
  return sortFailures failures

def nestedFailureCount (spaces : Array SpaceAudit) : Nat :=
  spaces.foldl (init := 0) fun total space =>
    total + space.failures.size + space.presentation.failures.size +
      space.traits.foldl (init := 0) fun subtotal trait => subtotal + trait.failures.size

def makeSummary
    (spaces : Array SpaceAudit) (failures : Array AuditFailure) : AuditSummary :=
  { spaces := spaces.size
    implemented := (spaces.filter (·.status == .implemented)).size
    notImplemented := (spaces.filter (·.status == .notImplemented)).size
    invalid := (spaces.filter (·.status == .invalid)).size
    traits := spaces.foldl (init := 0) fun total space => total + space.traits.size
    failures := failures.size + nestedFailureCount spaces }

/-- Build a deterministic audit of the explicitly scoped Pi-Base spaces. -/
def buildAuditReport : MetaM AuditReport := do
  let env ← getEnv
  let spaceRegistrations := getSpaceRegistrations env
  let certificateRegistrations := getCertificateRegistrations env
  let spaces ← expectedSpaceIds.mapM <|
    auditExpectedSpace env certificateRegistrations
  let failures := topLevelFailures spaceRegistrations certificateRegistrations
  return {
    schemaVersion := spaceAuditSchemaVersion
    scope := expectedSpaceIds
    catalogSchemaVersion := generatedCatalog.schemaVersion
    sourceHashes := generatedCatalog.sourceHashes
    summary := makeSummary spaces failures
    spaces
    failures
  }

/-- Whether the report has complete, valid coverage and no recorded failures. -/
def AuditReport.isSuccess (report : AuditReport) : Bool :=
  report.failures.isEmpty && report.summary.spaces == expectedSpaceIds.size &&
    report.summary.implemented == report.summary.spaces &&
    report.summary.notImplemented == 0 && report.summary.invalid == 0 &&
    report.summary.failures == 0

/-- The overall report status, distinguishing incomplete coverage from invalid audit data. -/
def AuditReport.status (report : AuditReport) : AuditStatus :=
  if !report.failures.isEmpty || report.summary.invalid > 0 then .invalid
  else if report.summary.notImplemented > 0 then .notImplemented
  else if report.isSuccess then .implemented
  else .invalid

def optionJson (encode : α → Json) : Option α → Json
  | some value => encode value
  | none => Json.null

def stringArrayJson (values : Array String) : Json :=
  Json.arr <| values.map toJson

def nameArrayJson (values : Array Name) : Json :=
  stringArrayJson <| values.map Name.toString

def assumptionArrayJson (values : Array AssumptionId) : Json :=
  stringArrayJson <| values.map assumptionString

def failureJson (entry : AuditFailure) : Json :=
  Json.mkObj [
    ("code", toJson entry.code),
    ("message", toJson entry.message)
  ]

def failuresJson (failures : Array AuditFailure) : Json :=
  Json.arr <| failures.map failureJson

def assumptionAuditJson (audit : AssumptionAudit) : Json :=
  Json.mkObj [
    ("expected", assumptionArrayJson audit.expected),
    ("declared", assumptionArrayJson audit.declared),
    ("used", assumptionArrayJson audit.used),
    ("valid", toJson audit.valid)
  ]

def axiomAuditJson (audit : AxiomAudit) : Json :=
  Json.mkObj [
    ("axioms", nameArrayJson audit.axioms),
    ("trusted", nameArrayJson audit.trusted),
    ("conditional", nameArrayJson audit.conditional),
    ("forbidden", nameArrayJson audit.forbidden)
  ]

def presentationAuditJson (audit : PresentationAudit) : Json :=
  Json.mkObj [
    ("carrier", optionJson (fun name => toJson name.toString) audit.carrier),
    ("canonicalHomeomorph",
      optionJson (fun name => toJson name.toString) audit.canonicalHomeomorph),
    ("typeValid", toJson audit.typeValid),
    ("assumptions", assumptionAuditJson audit.assumptions),
    ("axioms", axiomAuditJson audit.axioms),
    ("failures", failuresJson audit.failures),
    ("status", toJson <| statusString audit.status)
  ]

def traitAuditJson (audit : TraitAudit) : Json :=
  Json.mkObj [
    ("propertyId", toJson audit.propertyId),
    ("name", optionJson toJson audit.propertyName),
    ("expected", toJson audit.expected),
    ("polarity", toJson audit.polarity),
    ("certificate", optionJson (fun name => toJson name.toString) audit.certificate),
    ("provenance", optionJson (fun value => toJson <| provenanceString value)
      audit.provenance),
    ("typeValid", toJson audit.typeValid),
    ("assumptions", assumptionAuditJson audit.assumptions),
    ("axioms", axiomAuditJson audit.axioms),
    ("failures", failuresJson audit.failures),
    ("status", toJson <| statusString audit.status)
  ]

def spaceAuditJson (audit : SpaceAudit) : Json :=
  Json.mkObj [
    ("spaceId", toJson audit.spaceId),
    ("catalogName", optionJson toJson audit.catalogName),
    ("presentation", presentationAuditJson audit.presentation),
    ("traits", Json.arr <| audit.traits.map traitAuditJson),
    ("failures", failuresJson audit.failures),
    ("status", toJson <| statusString audit.status)
  ]

def summaryJson (summary : AuditSummary) : Json :=
  Json.mkObj [
    ("spaces", toJson summary.spaces),
    ("implemented", toJson summary.implemented),
    ("notImplemented", toJson summary.notImplemented),
    ("invalid", toJson summary.invalid),
    ("traits", toJson summary.traits),
    ("failures", toJson summary.failures)
  ]

/-- Deterministic JSON representation of an audit report. -/
def AuditReport.toJson (report : AuditReport) : Json :=
  Json.mkObj [
    ("schemaVersion", Lean.ToJson.toJson report.schemaVersion),
    ("scope", stringArrayJson report.scope),
    ("catalogSchemaVersion", Lean.ToJson.toJson report.catalogSchemaVersion),
    ("sourceHashes", Json.mkObj [
      ("pibase", Lean.ToJson.toJson report.sourceHashes.pibase),
      ("independence", Lean.ToJson.toJson report.sourceHashes.independence)
    ]),
    ("summary", summaryJson report.summary),
    ("spaces", Json.arr <| report.spaces.map spaceAuditJson),
    ("failures", failuresJson report.failures)
  ]

/-- Deterministic compact JSON serialization of an audit report. -/
def AuditReport.toJsonString (report : AuditReport) : String :=
  report.toJson.compress

instance : ToJson AuditReport where
  toJson := AuditReport.toJson

def AuditReport.summaryString (report : AuditReport) : String :=
  let summary := report.summary
  s!"Pi-Base space audit: {statusString report.status}\n\
    spaces: {summary.spaces}, implemented: {summary.implemented}, \
    not implemented: {summary.notImplemented}, invalid: {summary.invalid}\n\
    traits: {summary.traits}, failures: {summary.failures}"

syntax (name := auditPiBaseSpacesCmd) "#audit_pibase_spaces" : command
syntax (name := assertPiBaseSpacesCmd) "#assert_pibase_spaces" : command

elab_rules : command
  | `(#audit_pibase_spaces) => do
      let report ← Lean.Elab.Command.liftTermElabM buildAuditReport
      logInfo m!"{report.summaryString}\n{report.toJson.pretty}"
  | `(#assert_pibase_spaces) => do
      let report ← Lean.Elab.Command.liftTermElabM buildAuditReport
      unless report.isSuccess do
        throwError "{report.summaryString}\n{report.toJson.pretty}"

end PiBase.Audit.Spaces

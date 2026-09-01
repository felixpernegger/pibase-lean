module

public meta import PiBaseLean.Audit.Core.Meta
public meta import PiBaseLean.Audit.Spaces.GeneratedCatalog
public meta import PiBaseLean.Bundled.Defs

@[expose] public meta section

namespace PiBase.Audit.Spaces

open Lean

/-- Whether a certificate records source data or a derived theorem. -/
inductive CertificateProvenance where
  | direct
  | derived
  deriving Repr, Inhabited, DecidableEq

/-- Validated metadata connecting a catalog space to its Lean implementation. -/
structure SpaceRegistration where
  spaceId : String
  catalogName : String
  carrier : Name
  canonicalHomeomorph : Name
  assumptionIds : Array AssumptionId
  deriving Repr, Inhabited, DecidableEq

/-- Validated metadata connecting a catalog trait to a Lean proof. -/
structure CertificateRegistration where
  spaceId : String
  propertyId : String
  property : Name
  proof : Name
  polarity : Bool
  provenance : CertificateProvenance
  assumptionIds : Array AssumptionId
  deriving Repr, Inhabited, DecidableEq

private def addSpaceRegistration
    (state : Array SpaceRegistration) (entry : SpaceRegistration) : Array SpaceRegistration :=
  if state.contains entry then state else state.push entry

private def addCertificateRegistration
    (state : Array CertificateRegistration) (entry : CertificateRegistration) :
    Array CertificateRegistration :=
  if state.contains entry then state else state.push entry

initialize spaceRegistryExt :
    SimplePersistentEnvExtension SpaceRegistration (Array SpaceRegistration) ←
  registerSimplePersistentEnvExtension {
    addImportedFn := fun modules => modules.foldl (· ++ ·) #[]
    addEntryFn := addSpaceRegistration
  }

initialize certificateRegistryExt :
    SimplePersistentEnvExtension CertificateRegistration (Array CertificateRegistration) ←
  registerSimplePersistentEnvExtension {
    addImportedFn := fun modules => modules.foldl (· ++ ·) #[]
    addEntryFn := addCertificateRegistration
  }

/-- All space registrations visible in an environment. -/
def getSpaceRegistrations (env : Environment) : Array SpaceRegistration :=
  SimplePersistentEnvExtension.getState spaceRegistryExt env

/-- All certificate registrations visible in an environment. -/
def getCertificateRegistrations (env : Environment) : Array CertificateRegistration :=
  SimplePersistentEnvExtension.getState certificateRegistryExt env

/-- Find visible space registrations by catalog ID. -/
def findSpacesById (env : Environment) (spaceId : String) : Array SpaceRegistration :=
  (getSpaceRegistrations env).filter (·.spaceId == spaceId)

/-- Find visible space registrations by carrier declaration. -/
def findSpacesByCarrier (env : Environment) (carrier : Name) : Array SpaceRegistration :=
  (getSpaceRegistrations env).filter (·.carrier == carrier)

/-- Find visible space registrations by canonical-homeomorphism declaration. -/
def findSpacesByCanonical (env : Environment) (canonical : Name) : Array SpaceRegistration :=
  (getSpaceRegistrations env).filter (·.canonicalHomeomorph == canonical)

/-- Find visible certificate registrations by catalog space and property IDs. -/
def findCertificates (env : Environment) (spaceId propertyId : String) :
    Array CertificateRegistration :=
  (getCertificateRegistrations env).filter fun entry =>
    entry.spaceId == spaceId && entry.propertyId == propertyId

/-- Find visible certificate registrations by proof declaration. -/
def findCertificatesByProof (env : Environment) (proof : Name) :
    Array CertificateRegistration :=
  (getCertificateRegistrations env).filter (·.proof == proof)

/-- Retrieve a unique visible space registration. -/
def getSpaceById (env : Environment) (spaceId : String) : Except String SpaceRegistration :=
  match findSpacesById env spaceId with
  | #[entry] => .ok entry
  | #[] => .error s!"no space registration for {spaceId}"
  | entries => .error s!"ambiguous space registration for {spaceId}: {entries.size} entries"

/-- Retrieve a unique visible certificate registration. -/
def getCertificate (env : Environment) (spaceId propertyId : String) :
    Except String CertificateRegistration :=
  match findCertificates env spaceId propertyId with
  | #[entry] => .ok entry
  | #[] => .error s!"no certificate registration for {spaceId}/{propertyId}"
  | entries =>
      .error
        s!"ambiguous certificate registration for {spaceId}/{propertyId}: \
          {entries.size} entries"

def findCatalogSpace (spaceId : String) : Except String SpaceEntry :=
  match generatedCatalog.spaces.filter (·.id == spaceId) with
  | #[entry] => .ok entry
  | #[] => .error s!"unknown catalog space ID {spaceId}"
  | entries => .error s!"catalog space ID {spaceId} is duplicated ({entries.size} entries)"

def findCatalogProperty (propertyId : String) : Except String PropertyEntry :=
  match generatedCatalog.properties.filter (·.id == propertyId) with
  | #[entry] => .ok entry
  | #[] => .error s!"unknown catalog property ID {propertyId}"
  | entries => .error s!"catalog property ID {propertyId} is duplicated ({entries.size} entries)"

def propertyDeclName (propertyId : String) : Except String Name := do
  let digits := propertyId.drop 1
  unless propertyId.startsWith "P" && propertyId.length == 7 && digits.all Char.isDigit do
    throw s!"invalid canonical property ID {propertyId}"
  let some propertyNumber := digits.toNat?
    | throw s!"invalid canonical property ID {propertyId}"
  if propertyNumber == 0 then
    throw s!"invalid canonical property ID {propertyId}"
  return s!"PiBase.Formal.P{propertyNumber}".toName

def resolveDecl (stx : Syntax) : Lean.Elab.Command.CommandElabM Name :=
  Lean.Elab.Command.liftCoreM <| Lean.Elab.realizeGlobalConstNoOverloadWithInfo stx

/--
Validate catalog assumptions. Conditional registrations are deliberately rejected until their
binder types can also be validated, so this check fails closed for every nonempty list.
-/
def checkAssumptions
    (description : String) (actual expected : Array AssumptionId) :
    Lean.Elab.Command.CommandElabM Unit := do
  unless actual == expected do
    throwError
      "{description} assumptions do not match generatedCatalog\nactual:   {repr actual}\nexpected: \
        {repr expected}"
  unless actual.isEmpty do
    throwError "conditional assumption binders are not yet supported for {description}"

def canonicalHomeomorphArgs (canonicalName : Name) : Meta.MetaM (Array Expr) := do
  let canonical ← Meta.mkConstWithFreshMVarLevels canonicalName
  let canonicalType ← Meta.whnf (← Meta.inferType canonical)
  let (head, args) := canonicalType.getAppFnArgs
  unless head == ``Homeomorph && args.size == 4 do
    throwError
      "canonical declaration {canonicalName} is not a monomorphic homeomorphism; it has type \
        {canonicalType}"
  return args

/-- Resolve and validate the declaration facts shared by registration-time and audit-time checks. -/
def validateSpaceDeclsCore
    (carrierName canonicalName : Name) : Meta.MetaM (Expr × Array Expr) := do
  PiBase.Audit.Meta.assertKernelChecked "space carrier" carrierName
  PiBase.Audit.Meta.assertKernelChecked "canonical homeomorphism" canonicalName
  let carrier ← Meta.mkConstWithFreshMVarLevels carrierName
  let carrierType ← Meta.whnf (← Meta.inferType carrier)
  let .sort level := carrierType
    | throwError "space carrier {carrierName} is not a type; it has type {carrierType}"
  if level == .zero then
    throwError "space carrier {carrierName} is a proposition, not a type"
  let args ← canonicalHomeomorphArgs canonicalName
  PiBase.Audit.Meta.assertDefEq
    s!"canonical homeomorphism {canonicalName} has the wrong source"
    args[0]!
    carrier
  return (carrier, args)

/-- Validate the stable declaration facts recorded in a space registration. -/
def validateSpaceDecls (carrierName canonicalName : Name) : Meta.MetaM Unit := do
  discard <| validateSpaceDeclsCore carrierName canonicalName

/--
Validate a new registration against the topology instance visible at the registration site.

The final audit deliberately uses `validateSpaceDecls` instead: re-synthesizing this instance after
later imports would make an existing registration depend on import order.
-/
def validateSpaceRegistrationDecls
    (carrierName canonicalName : Name) : Meta.MetaM Unit := do
  let (carrier, args) ← validateSpaceDeclsCore carrierName canonicalName
  let topologyType ← Meta.mkAppM ``TopologicalSpace #[carrier]
  let topology ← try
    Meta.synthInstance topologyType
  catch _ =>
    throwError "failed to synthesize TopologicalSpace {carrierName}"
  PiBase.Audit.Meta.assertDefEq
    s!"canonical homeomorphism {canonicalName} uses the wrong source topology"
    args[2]!
    topology

def checkLocalSpaceRegistration
    (env : Environment) (entry : SpaceRegistration) : Lean.Elab.Command.CommandElabM Unit := do
  let localEntries := SimplePersistentEnvExtension.getEntries spaceRegistryExt env
  for previous in localEntries do
    if previous.spaceId == entry.spaceId then
      if previous == entry then
        throwError "duplicate local space registration for {entry.spaceId}"
      else
        throwError "conflicting local space registration for {entry.spaceId}"
    if previous.carrier == entry.carrier then
      throwError "carrier {entry.carrier} is already registered locally as {previous.spaceId}"
    if previous.canonicalHomeomorph == entry.canonicalHomeomorph then
      throwError
        "canonical homeomorphism {entry.canonicalHomeomorph} is already registered locally as \
          {previous.spaceId}"

def checkLocalCertificateRegistration
    (env : Environment) (entry : CertificateRegistration) :
    Lean.Elab.Command.CommandElabM Unit := do
  let localEntries := SimplePersistentEnvExtension.getEntries certificateRegistryExt env
  for previous in localEntries do
    if previous.spaceId == entry.spaceId && previous.propertyId == entry.propertyId then
      if previous == entry then
        throwError
          "duplicate local certificate registration for {entry.spaceId}/{entry.propertyId}"
      else
        throwError
          "conflicting local certificate registration for {entry.spaceId}/{entry.propertyId}"
    if previous.proof == entry.proof then
      throwError
        "proof {entry.proof} is already registered locally for \
          {previous.spaceId}/{previous.propertyId}"

def validateCertificateDecls
    (space : SpaceRegistration) (propertyName proofName : Name) (polarity : Bool) :
    Meta.MetaM Unit := do
  PiBase.Audit.Meta.assertKernelChecked "property declaration" propertyName
  PiBase.Audit.Meta.assertKernelChecked "certificate declaration" proofName
  let carrier ← Meta.mkConstWithFreshMVarLevels space.carrier
  let carrierType ← Meta.whnf (← Meta.inferType carrier)
  let .sort (.succ carrierLevel) := carrierType
    | throwError "registered carrier {space.carrier} is not in Type"
  let property := mkConst propertyName [carrierLevel]
  let propertyType ← Meta.inferType property
  let bundledProperty := mkConst ``PiBase.Formal.Property [carrierLevel]
  PiBase.Audit.Meta.assertDefEq
    s!"property declaration {propertyName} does not have type PiBase.Formal.Property"
    propertyType
    bundledProperty
  let canonicalArgs ← canonicalHomeomorphArgs space.canonicalHomeomorph
  PiBase.Audit.Meta.assertDefEq
    s!"registered canonical homeomorphism {space.canonicalHomeomorph} has the wrong source"
    canonicalArgs[0]!
    carrier
  let topology := canonicalArgs[2]!
  let proposition ← Meta.mkAppOptM ``PiBase.Formal.Property.toPred
    #[some property, some carrier, some topology]
  let expected ← if polarity then pure proposition else Meta.mkAppM ``Not #[proposition]
  let proof ← Meta.mkConstWithFreshMVarLevels proofName
  let proofType ← Meta.inferType proof
  PiBase.Audit.Meta.assertDefEq
    s!"certificate {proofName} has the wrong type for {space.spaceId}"
    proofType
    expected

declare_syntax_cat auditAssumption
syntax ident : auditAssumption

declare_syntax_cat auditAssumptions
syntax "[" auditAssumption,* "]" : auditAssumptions

def parseAssumption (stx : Syntax) : Lean.Elab.Command.CommandElabM AssumptionId := do
  let `(auditAssumption| $assumption:ident) := stx
    | throwErrorAt stx "invalid Pi-Base assumption"
  match assumption.getId.toString with
  | "continuumHypothesis" => pure AssumptionId.continuumHypothesis
  | "notContinuumHypothesis" => pure AssumptionId.notContinuumHypothesis
  | "martinsAxiom" => pure AssumptionId.martinsAxiom
  | "generalizedContinuumHypothesis" =>
      pure AssumptionId.generalizedContinuumHypothesis
  | _ => throwErrorAt assumption "unknown Pi-Base assumption"

def parseAssumptions (stx : Syntax) :
    Lean.Elab.Command.CommandElabM (Array AssumptionId) := do
  let `(auditAssumptions| [$[$assumptions],*]) := stx
    | throwErrorAt stx "invalid Pi-Base assumption list"
  assumptions.mapM parseAssumption

def parsePolarity (stx : Syntax) : Lean.Elab.Command.CommandElabM Bool :=
  match stx.getId.toString with
  | "true" => pure true
  | "false" => pure false
  | _ => throwErrorAt stx "certificate polarity must be true or false"

def parseProvenance (stx : Syntax) :
    Lean.Elab.Command.CommandElabM CertificateProvenance :=
  match stx.getId.toString with
  | "direct" => pure CertificateProvenance.direct
  | "derived" => pure CertificateProvenance.derived
  | _ => throwErrorAt stx "certificate provenance must be direct or derived"

def checkFieldLabel (stx : Syntax) (expected : String) :
    Lean.Elab.Command.CommandElabM Unit :=
  unless stx.getId.toString == expected do
    throwErrorAt stx "expected '{expected}'"

syntax (name := registerSpaceCmd)
  "register_space" ident ident ident ident ident ident auditAssumptions : command

syntax (name := registerCertificateCmd)
  "register_certificate" ident ident ident ident ident ident ident ident auditAssumptions : command

elab_rules : command
  | `(register_space $spaceIdStx:ident
      $carrierLabel:ident $carrierStx:ident
      $canonicalLabel:ident $canonicalStx:ident
      $assumptionsLabel:ident $assumptionsStx:auditAssumptions) => do
    checkFieldLabel carrierLabel "carrier"
    checkFieldLabel canonicalLabel "canonical"
    checkFieldLabel assumptionsLabel "assumptions"
    let spaceId := spaceIdStx.getId.toString
    let catalogEntry ← match findCatalogSpace spaceId with
      | .ok entry => pure entry
      | .error message => throwErrorAt spaceIdStx message
    let assumptionIds ← parseAssumptions assumptionsStx
    checkAssumptions s!"space {spaceId}" assumptionIds catalogEntry.conditionalAssumptions
    let carrierName ← resolveDecl carrierStx
    let canonicalName ← resolveDecl canonicalStx
    Lean.Elab.Command.liftTermElabM <|
      validateSpaceRegistrationDecls carrierName canonicalName
    let entry : SpaceRegistration := {
      spaceId
      catalogName := catalogEntry.name
      «carrier» := carrierName
      canonicalHomeomorph := canonicalName
      assumptionIds
    }
    let env ← getEnv
    checkLocalSpaceRegistration env entry
    setEnv <| spaceRegistryExt.addEntry env entry

elab_rules : command
  | `(register_certificate $spaceIdStx:ident $propertyIdStx:ident $polarityStx:ident
      $proofLabel:ident $proofStx:ident
      $provenanceLabel:ident $provenanceStx:ident
      $assumptionsLabel:ident $assumptionsStx:auditAssumptions) => do
    checkFieldLabel proofLabel "proof"
    checkFieldLabel provenanceLabel "provenance"
    checkFieldLabel assumptionsLabel "assumptions"
    let spaceId := spaceIdStx.getId.toString
    let propertyId := propertyIdStx.getId.toString
    let catalogSpace ← match findCatalogSpace spaceId with
      | .ok entry => pure entry
      | .error message => throwErrorAt spaceIdStx message
    discard <| match findCatalogProperty propertyId with
      | .ok entry => pure entry
      | .error message => throwErrorAt propertyIdStx message
    let env ← getEnv
    let space ← match getSpaceById env spaceId with
      | .ok entry => pure entry
      | .error message => throwErrorAt spaceIdStx message
    let assumptionIds ← parseAssumptions assumptionsStx
    checkAssumptions
      s!"certificate {spaceId}/{propertyId}"
      assumptionIds
      catalogSpace.conditionalAssumptions
    unless assumptionIds == space.assumptionIds do
      throwError "certificate assumptions differ from the registered space assumptions"
    let polarity ← parsePolarity polarityStx
    let provenanceValue ← parseProvenance provenanceStx
    let directMatches := catalogSpace.directTraits.filter (·.propertyId == propertyId)
    match provenanceValue with
    | .direct =>
        match directMatches with
        | #[trait] =>
            unless trait.value == polarity do
              throwError
                "catalog polarity for {spaceId}/{propertyId} is {trait.value}, not {polarity}"
        | #[] => throwError "{spaceId}/{propertyId} is not a direct generated-catalog trait"
        | entries =>
            throwError
              "generatedCatalog has {entries.size} direct traits for {spaceId}/{propertyId}"
    | .derived =>
        unless directMatches.isEmpty do
          throwError
            "{spaceId}/{propertyId} is a direct generated-catalog trait and cannot be registered \
              as derived"
    let propertyName ← match propertyDeclName propertyId with
      | .ok name => pure name
      | .error message => throwErrorAt propertyIdStx message
    discard <| getConstInfo propertyName
    let proofName ← resolveDecl proofStx
    Lean.Elab.Command.liftTermElabM <|
      validateCertificateDecls space propertyName proofName polarity
    let entry : CertificateRegistration := {
      spaceId
      propertyId
      property := propertyName
      «proof» := proofName
      polarity
      «provenance» := provenanceValue
      assumptionIds
    }
    checkLocalCertificateRegistration env entry
    setEnv <| certificateRegistryExt.addEntry env entry

end PiBase.Audit.Spaces

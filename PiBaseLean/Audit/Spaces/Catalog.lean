module

-- Stable handwritten schema for the generated space audit catalog.
-- It defines data only and makes no claims about Lean declarations or proofs.

@[expose] public section

namespace PiBase.Audit.Spaces

/-- Stable identifiers for the set-theoretic assumptions recognized by the source data. -/
inductive AssumptionId where
  | continuumHypothesis
  | notContinuumHypothesis
  | martinsAxiom
  | generalizedContinuumHypothesis
  deriving Repr, DecidableEq

/-- A supported source assumption label and its stable identifier. -/
structure AssumptionEntry where
  id : AssumptionId
  label : String
  deriving Repr, DecidableEq

/-- A property in the source catalog. IDs retain their canonical padded form. -/
structure PropertyEntry where
  id : String
  name : String
  deriving Repr, DecidableEq

/-- A direct source-catalog obligation. `value` is its Boolean polarity. -/
structure TraitObligation where
  propertyId : String
  value : Bool
  deriving Repr, DecidableEq

/-- A space and its source-catalog obligations, independent of Lean implementation status. -/
structure SpaceEntry where
  id : String
  name : String
  directTraits : Array TraitObligation
  conditionalAssumptions : Array AssumptionId
  deriving Repr, DecidableEq

/-- SHA-256 hashes of the exact source input bytes. -/
structure SourceHashes where
  pibase : String
  independence : String
  deriving Repr, DecidableEq

/-- Complete source data used by the space audit. -/
structure Catalog where
  schemaVersion : Nat
  sourceHashes : SourceHashes
  assumptions : Array AssumptionEntry
  properties : Array PropertyEntry
  spaces : Array SpaceEntry
  deriving Repr, DecidableEq

end PiBase.Audit.Spaces

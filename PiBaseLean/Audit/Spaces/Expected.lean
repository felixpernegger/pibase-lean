module

public import PiBaseLean.Audit.Spaces.GeneratedCatalog

@[expose] public section

namespace PiBase.Audit.Spaces

/-- The version of the machine-readable final space-audit report. -/
def spaceAuditSchemaVersion : Nat := 1

/-- The catalog schema understood by the final space audit. -/
def supportedCatalogSchemaVersion : Nat := 1

/--
The explicit scope of the final Lean-native audit.

This list is deliberately independent of the registry and the generated space aggregate, so a
missing `Lemmas` import remains observable as missing coverage.
-/
def expectedSpaceIds : Array String :=
  #["S000001", "S000004", "S000010", "S000189"]

/-- All source-catalog entries matching an expected space ID. -/
def expectedCatalogMatches (spaceId : String) : Array SpaceEntry :=
  generatedCatalog.spaces.filter (·.id == spaceId)

/--
Structured expected entries in explicit scope order. Missing or duplicate catalog entries are left
for the audit to report from `expectedCatalogMatches`.
-/
def expectedSpaces : Array SpaceEntry :=
  expectedSpaceIds.filterMap fun spaceId =>
    match expectedCatalogMatches spaceId with
    | #[space] => some space
    | _ => none

/-- All catalog properties matching a canonical property ID. -/
def expectedPropertyMatches (propertyId : String) : Array PropertyEntry :=
  generatedCatalog.properties.filter (·.id == propertyId)

end PiBase.Audit.Spaces

module

public import Mathlib.Topology.NoetherianSpace
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open TopologicalSpace

namespace PiBase

/- 226. Artinian -/
abbrev ArtinianSpace (X : Type*) [TopologicalSpace X] := WellFoundedGT (Closeds X)

end PiBase

namespace PiBase.Formal

def P226 : Property where
  toPred := ArtinianSpace
  well_defined φ h := sorry

end PiBase.Formal

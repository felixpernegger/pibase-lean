module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P36.Defs
public import PiBaseLean.Properties.P189.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T484: P189 (SigmaConnectedSpace) => P36 (PreconnectedSpace) -/
theorem instPreconnectedSpaceOfSigmaConnectedSpace (X : Type u)
    [TopologicalSpace X] [SigmaConnectedSpace X] :
    PreconnectedSpace X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T484 : P189 ≤ P36 := fun X _ ↦ @instPreconnectedSpaceOfSigmaConnectedSpace X _

end PiBase.Formal

module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P36.Defs
public import PiBaseLean.Properties.P37.Lemmas

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T40: P37 (PrepathConnectedSpace) => P36 (PreconnectedSpace) -/
instance instPreconnectedSpaceOfPrepathConnectedSpace (X : Type u)
    [TopologicalSpace X] [PrepathConnectedSpace X] :
    PreconnectedSpace X := by
  by_cases! IsEmpty X
  · infer_instance
  · infer_instance

end PiBase

namespace PiBase.Formal

theorem T40 : P37 ≤ P36 := fun X _ ↦ @instPreconnectedSpaceOfPrepathConnectedSpace X _

end PiBase.Formal

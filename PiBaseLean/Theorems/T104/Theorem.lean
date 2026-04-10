module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P2.Defs
public import PiBaseLean.Properties.P35.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

-- Most likely redundant
/-- Theorem T104: P35 (FullyT4Space) => P2 (T1Space) -/
theorem instT1SpaceOfFullyT4Space (X : Type u)
    [TopologicalSpace X] [FullyT4Space X] :
    T1Space X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T104 : P35 ≤ P2 := fun X _ ↦ @instT1SpaceOfFullyT4Space X _

end PiBase.Formal

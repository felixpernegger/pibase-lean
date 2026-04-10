module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P2.Defs
public import PiBaseLean.Properties.P7.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

-- Most likely redundant
/-- Theorem T98: P7 (T4Space) => P2 (T1Space) -/
theorem instT1SpaceOfT4Space (X : Type u)
    [TopologicalSpace X] [T4Space X] :
    T1Space X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T98 : P7 ≤ P2 := fun X _ ↦ @instT1SpaceOfT4Space X _

end PiBase.Formal

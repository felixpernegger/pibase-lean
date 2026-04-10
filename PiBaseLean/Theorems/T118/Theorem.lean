module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P2.Defs
public import PiBaseLean.Properties.P3.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

-- Most likely redundant
/-- Theorem T118: P3 (T2Space) => P2 (T1Space) -/
theorem instT1SpaceOfT2Space (X : Type u)
    [TopologicalSpace X] [T2Space X] :
    T1Space X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T118 : P3 ≤ P2 := fun X _ ↦ @instT1SpaceOfT2Space X _

end PiBase.Formal

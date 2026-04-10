module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P3.Defs
public import PiBaseLean.Properties.P134.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T281: P3 (T2Space) => P134 (R1Space) -/
theorem instR1SpaceOfT2Space (X : Type u)
    [TopologicalSpace X] [T2Space X] :
    R1Space X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T281 : P3 ≤ P134 := fun X _ ↦ @instR1SpaceOfT2Space X _

end PiBase.Formal

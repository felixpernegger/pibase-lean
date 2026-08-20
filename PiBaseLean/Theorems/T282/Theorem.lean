module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P11.Bundled
public import PiBaseLean.Properties.P134.Bundled

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T282: P11 (RegularSpace) => P134 (R1Space) -/
theorem instR1SpaceOfRegularSpace (X : Type u)
    [TopologicalSpace X] [RegularSpace X] :
    R1Space X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T282 : P11 ≤ P134 := fun X _ ↦ @instR1SpaceOfRegularSpace X _

end PiBase.Formal

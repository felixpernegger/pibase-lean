module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P134.Defs
public import PiBaseLean.Properties.P135.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T286: P134 (R1Space) => P135 (R0Space) -/
theorem instR0SpaceOfR1Space (X : Type u)
    [TopologicalSpace X] [R1Space X] :
    R0Space X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T286 : P134 ≤ P135 := fun X _ ↦ @instR0SpaceOfR1Space X _

end PiBase.Formal

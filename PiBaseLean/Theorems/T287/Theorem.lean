module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P2.Defs
public import PiBaseLean.Properties.P135.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T287: P2 (T1Space) => P135 (R0Space) -/
theorem instR0SpaceOfT1Space (X : Type u)
    [TopologicalSpace X] [T1Space X] :
    R0Space X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T287 : P2 ≤ P135 := fun X _ ↦ @instR0SpaceOfT1Space X _

end PiBase.Formal

module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P1.Defs
public import PiBaseLean.Properties.P2.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T119: P2 (T1Space) => P1 (T0Space) -/
theorem instT0SpaceOfT1Space (X : Type u)
    [TopologicalSpace X] [T1Space X] :
    T0Space X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T119 : P2 ≤ P1 := fun X _ ↦ @instT0SpaceOfT1Space X _

end PiBase.Formal

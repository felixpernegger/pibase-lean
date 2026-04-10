module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P6.Defs
public import PiBaseLean.Properties.P63.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T610: P63 (CechCompleteSpace) => P6 (T35Space) -/
theorem instT35SpaceOfCechCompleteSpace (X : Type u)
    [TopologicalSpace X] [CechCompleteSpace X] :
    T35Space X := by tauto

end PiBase

namespace PiBase.Formal

theorem T610 : P63 ≤ P6 := fun X _ ↦ @instT35SpaceOfCechCompleteSpace X _

end PiBase.Formal

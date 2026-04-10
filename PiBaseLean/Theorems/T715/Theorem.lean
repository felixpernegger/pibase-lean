module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P110.Defs
public import PiBaseLean.Properties.P113.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T715: P113 (MooreSpace) => P110 (DevelopableSpace) -/
theorem instDevelopableSpaceOfMooreSpace (X : Type u)
    [TopologicalSpace X] [MooreSpace X] :
    DevelopableSpace X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T715 : P113 ≤ P110 := fun X _ ↦ @instDevelopableSpaceOfMooreSpace X _

end PiBase.Formal

module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P116.Bundled
public import PiBaseLean.Properties.P26.Bundled

@[expose] public section

universe u

open TopologicalSpace

namespace PiBase

/-- Theorem T199: P116 (PolishSpace) => P26 (SeparableSpace) -/
theorem instSeparableSpaceOfPolishSpace {X : Type u}
    [TopologicalSpace X] [PolishSpace X] :
    SeparableSpace X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T199 : P116 ≤ P26 := fun X _ ↦ @instSeparableSpaceOfPolishSpace X _

end PiBase.Formal

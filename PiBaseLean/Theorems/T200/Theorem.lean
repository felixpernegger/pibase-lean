module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P116.Bundled
public import PiBaseLean.Properties.P55.Bundled

@[expose] public section

universe u

open TopologicalSpace

namespace PiBase

/-- Theorem T200: P116 (PolishSpace) => P55 (IsCompletelyMetrizableSpace) -/
theorem instIsCompletelyMetrizableSpaceOfPolishSpace {X : Type u}
    [TopologicalSpace X] [PolishSpace X] :
    IsCompletelyMetrizableSpace X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T200 : P116 ≤ P55 := fun X _ ↦ @instIsCompletelyMetrizableSpaceOfPolishSpace X _

end PiBase.Formal

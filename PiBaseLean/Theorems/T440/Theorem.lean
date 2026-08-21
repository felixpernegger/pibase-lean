module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P180.Bundled
public import PiBaseLean.Properties.P26.Bundled

@[expose] public section

universe u

open TopologicalSpace

namespace PiBase

/-- Theorem T440: P180 (HereditarilySeparableSpace) => P26 (SeparableSpace) -/
instance instSeparableSpaceOfHereditarilySeparableSpace {X : Type u}
    [TopologicalSpace X] [h : HereditarilySeparableSpace X] : SeparableSpace X :=
  Hereditarily.toProperty WellDefined.separableSpace h.subset_separable

end PiBase

namespace PiBase.Formal

theorem T440 : P180 ≤ P26 := fun X _ ↦ @instSeparableSpaceOfHereditarilySeparableSpace X _

end PiBase.Formal

module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P16.Bundled
public import PiBaseLean.Properties.P208.Bundled

@[expose] public section

universe u

open TopologicalSpace

namespace PiBase

/-- Theorem T650: P208 (NoetherianSpace) => P16 (CompactSpace) -/
theorem instCompactSpaceOfNoetherianSpace {X : Type u}
    [TopologicalSpace X] [NoetherianSpace X] :
    CompactSpace X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T650 : P208 ≤ P16 := fun X _ ↦ @instCompactSpaceOfNoetherianSpace X _

end PiBase.Formal

module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P16.Bundled
public import PiBaseLean.Properties.P75.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T339: P75 (SpectralSpace) => P16 (CompactSpace) -/
theorem instCompactSpaceOfSpectralSpace {X : Type u}
    [TopologicalSpace X] [SpectralSpace X] :
    CompactSpace X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T339 : P75 ≤ P16 := fun X _ ↦ @instCompactSpaceOfSpectralSpace X _

end PiBase.Formal

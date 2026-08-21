module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P130.Bundled
public import PiBaseLean.Properties.P23.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T245: P130 (LocallyCompactSpace) => P23 (WeaklyLocallyCompactSpace) -/
theorem instWeaklyLocallyCompactSpaceOfLocallyCompactSpace {X : Type u}
    [TopologicalSpace X] [LocallyCompactSpace X] : WeaklyLocallyCompactSpace X := by
  infer_instance

end PiBase

namespace PiBase.Formal

theorem T245 : P130 ≤ P23 := fun X _ _ ↦ by
  simp_all only [P130, P23]
  infer_instance

end PiBase.Formal

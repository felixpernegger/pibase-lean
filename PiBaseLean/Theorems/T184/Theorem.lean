module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P79.Bundled
public import PiBaseLean.Properties.P80.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T184: P80 (FrechetUrysohnSpace) => P79 (SequentialSpace) -/
theorem instSequentialSpaceOfFrechetUrysohnSpace {X : Type u}
    [TopologicalSpace X] [FrechetUrysohnSpace X] : SequentialSpace X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T184 : P80 ≤ P79 := fun X _ _ ↦ by
  simp_all only [P80, P79]
  infer_instance

end PiBase.Formal

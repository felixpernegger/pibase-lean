module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P13.Bundled
public import PiBaseLean.Properties.P14.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T36: P14 (CompletelyNormalSpace) => P13 (NormalSpace) -/
theorem instNormalSpaceOfCompletelyNormalSpace {X : Type u}
    [TopologicalSpace X] [CompletelyNormalSpace X] : NormalSpace X := by
  infer_instance

end PiBase

namespace PiBase.Formal

theorem T36 : P14 ≤ P13 := fun X _ _ ↦ by
  simp_all only [P14, P13]
  infer_instance

end PiBase.Formal

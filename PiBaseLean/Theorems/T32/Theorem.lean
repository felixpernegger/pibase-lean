module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P3.Bundled
public import PiBaseLean.Properties.P4.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T32: P4 (T25Space) => P3 (T2Space) -/
theorem instT2SpaceOfT25Space {X : Type u}
  [TopologicalSpace X] [T25Space X] : T2Space X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T32 : P4 ≤ P3 := fun X _ _ ↦ by
  simp_all only [P4, P3]
  infer_instance

end PiBase.Formal

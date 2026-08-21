module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P7.Bundled
public import PiBaseLean.Properties.P8.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T112: P8 (T5Space) => P7 (T4Space) -/
theorem instT4SpaceOfT5Space {X : Type u} [TopologicalSpace X] [T5Space X] : T4Space X := by
  infer_instance

end PiBase

namespace PiBase.Formal

theorem T112 : P8 ≤ P7 := fun X _ _ ↦ by
  simp_all only [P8, P7]
  infer_instance

end PiBase.Formal

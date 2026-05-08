module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P6.Defs
public import PiBaseLean.Properties.P7.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T113: P7 (T4Space) => P6 (T35Space) -/
theorem instT35SpaceOfT4Space (X : Type u) [TopologicalSpace X] [T4Space X] : T35Space X := by
  infer_instance

end PiBase

namespace PiBase.Formal

theorem T113 : P7 ≤ P6 := fun X _ _ ↦ by
  simp_all only [P7, P6]
  infer_instance

end PiBase.Formal

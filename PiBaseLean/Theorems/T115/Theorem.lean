module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P5.Defs
public import PiBaseLean.Properties.P6.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T115: P6 (T35Space) => P5 (T3Space) -/
theorem instT3SpaceOfT35Space (X : Type u) [TopologicalSpace X] [T35Space X] : T3Space X :=
  instT3Space

end PiBase

namespace PiBase.Formal

theorem T115 : P6 ≤ P5 := fun X _ _ ↦ by
  simp_all only [P6, P5]
  infer_instance

end PiBase.Formal

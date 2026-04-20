module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P1.Defs
public import PiBaseLean.Properties.P5.Defs
public import PiBaseLean.Properties.P11.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T148: P11 (RegularSpace) + P1 (T0Space) => P5 (T3Space) -/
theorem instT3SpaceOfRegularSpaceOfT0Space (X : Type u)
    [TopologicalSpace X] [RegularSpace X] [T0Space X] : T3Space X := by
  infer_instance

end PiBase

namespace PiBase.Formal

theorem T148 : P11 ⊓ P1 ≤ P5 := fun X _ ⟨_, _⟩ ↦ by
  simp_all only [P11, P1, P5]
  infer_instance

end PiBase.Formal

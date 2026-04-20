module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P1.Defs
public import PiBaseLean.Properties.P6.Defs
public import PiBaseLean.Properties.P12.Defs

@[expose] public section

universe u

open Topology Set Function TopologicalSpace

namespace PiBase

/-- Theorem T151: P12 (CompletelyRegularSpace) + P1 (T0Space) => P6 (T35Space) -/
theorem instT35SpaceOfCompletelyRegularSpaceOfT0Space (X : Type u)
    [TopologicalSpace X] [h : CompletelyRegularSpace X] [h' : T0Space X] : T35Space X := by
  tauto

end PiBase

namespace PiBase.Formal

theorem T151 : P12 ⊓ P1 ≤ P6 := fun X _ ⟨_, _⟩ ↦ by
  simp_all only [P12, P1, P6]
  tauto

end PiBase.Formal

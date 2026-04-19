module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P9.Lemmas
public import PiBaseLean.Properties.P48.Lemmas
public import Mathlib.Topology.Algebra.Indicator

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T48: P48 (TotallySeparatedSpace) => P9 (FunctionallyT2Space) -/
instance instFunctionallyT2SpaceOfTotallySeparatedSpace (X : Type u)
    [TopologicalSpace X] [h : TotallySeparatedSpace X] : FunctionallyT2Space X where
  functionally_t2 x y xy := by
    obtain ⟨U, hU, yU, xU⟩ := totallySeparatedSpace_iff_exists_isClopen.mp h xy.symm
    refine ⟨⟨indicator U (fun _ ↦ (1 : unitInterval)), ?_⟩, ?_⟩
    · refine IsClopen.continuous_indicator hU continuous_const
    simp_all

end PiBase

namespace PiBase.Formal

theorem T48 : P48 ≤ P9 := fun X _ ↦ @instFunctionallyT2SpaceOfTotallySeparatedSpace X _

end PiBase.Formal

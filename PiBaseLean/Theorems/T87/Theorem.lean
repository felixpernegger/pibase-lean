module

public import PiBaseLean.Properties.Bundled.Basic
public import Mathlib.Topology.Clopen
public import PiBaseLean.Properties.P40.Defs
public import PiBaseLean.Properties.P218.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T87: P40 (UltraconnectedSpace) => P218 (UltranormalSpace) -/
instance instUltranormalSpaceOfUltraconnectedSpace (X : Type u)
    [TopologicalSpace X] [h : UltraconnectedSpace X] :
    UltranormalSpace X where
  disjoint_clopen := by
    intro s t st sc tc
    rcases eq_or_ne s ∅ with h'|h'
    · exact ⟨∅, isClopen_empty, by simpa⟩
    refine ⟨univ, isClopen_univ, subset_univ s, ?_⟩
    simp only [compl_univ, subset_empty_iff]
    by_contra h0
    have := h.ultraconnected s t sc tc (nonempty_iff_empty_ne.mpr h'.symm)
      (nonempty_iff_empty_ne.mpr (Ne.symm h0))
    exact Set.not_disjoint_iff_nonempty_inter.2 this st

end PiBase

namespace PiBase.Formal

theorem T87 : P40 ≤ P218 := fun X _ ↦ @instUltranormalSpaceOfUltraconnectedSpace X _

end PiBase.Formal

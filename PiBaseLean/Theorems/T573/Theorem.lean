module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P51.Lemmas
public import PiBaseLean.Properties.P203.Lemmas

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T573: P203 (AlmostDiscreteSpace) => P51 (ScatteredSpace) -/
instance instScatteredSpaceOfAlmostDiscreteSpace (X : Type u)
    [TopologicalSpace X] [h : AlmostDiscreteSpace X] : ScatteredSpace X where
  scattered s sn := by
    obtain ⟨p, hp⟩ := h.ex_point
    by_cases! ss : s.Subsingleton
    · obtain ⟨x, hx⟩ := sn
      refine ⟨⟨x, hx⟩ , ?_⟩
      have : DiscreteTopology s :=
        @Subsingleton.discreteTopology s instTopologicalSpaceSubtype ss.coe_sort
      exact isOpen_discrete ({⟨x, hx⟩} : Set s)
    obtain ⟨x, xs, xp⟩ := ss.exists_ne p
    refine ⟨⟨x, xs⟩, {x}, (hp x).mp xp, ?_⟩
    ext y
    simp only [mem_preimage, mem_singleton_iff]
    rw [← Subtype.val_inj]

end PiBase

namespace PiBase.Formal

theorem T573 : P203 ≤ P51 := fun X _ ↦ @instScatteredSpaceOfAlmostDiscreteSpace X _

end PiBase.Formal

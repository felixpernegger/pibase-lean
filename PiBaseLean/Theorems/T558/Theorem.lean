module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P175.Defs
public import PiBaseLean.Properties.P204.Defs

@[expose] public section

universe u

open Topology Set Function Cardinal

namespace PiBase

/-- Theorem T558: P204 (HasACutPoint) => P175 (CardGeThree) -/
instance instCardGeThreeOfHasACutPoint (X : Type u)
    [TopologicalSpace X] [h : HasACutPoint X] :
    CardGeThree X where
  card_ge := by
    by_contra! h0
    obtain ⟨p, hp⟩ := h
    have : Subsingleton ({p}ᶜ : Set X) := by
      apply Cardinal.le_one_iff_subsingleton.mp
      have pm : p ∉ {p}ᶜ := notMem_compl_iff.mpr rfl
      have : Set.univ = insert p {p}ᶜ := by ext; simp [(ne_or_eq _ _).symm]
      rw [← Cardinal.mk_univ, this, Cardinal.mk_insert pm] at h0
      have : Cardinal.mk ↑({p}ᶜ : Set X) < 2 := by
        contrapose! h0
        calc
          3 = 2 + 1 := by norm_num
          _ ≤ Cardinal.mk ↑({p}ᶜ : Set X) + 1 := by
            exact Cardinal.add_one_le_add_one_iff.mpr h0
      contrapose! this
      exact Cardinal.two_le_iff_one_lt.mpr this
    unfold IsCutPoint at hp
    contrapose! hp
    apply isPreconnected_iff_preconnectedSpace.mpr
    infer_instance

end PiBase

namespace PiBase.Formal

theorem T558 : P204 ≤ P175 := fun X _ ↦ @instCardGeThreeOfHasACutPoint X _

end PiBase.Formal

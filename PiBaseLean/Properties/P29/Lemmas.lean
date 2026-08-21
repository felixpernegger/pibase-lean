module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P29.Defs

@[expose] public section

namespace PiBase

open Set Function

lemma Set.countable_of_setminus_singleton {α : Type*} {s : Set α} {a : α}
    (h : (s \ {a}).Countable) : s.Countable :=
  Countable.of_sdiff h <| countable_singleton a

theorem countableChainCondition_iff_ex_nonempty_chain (X : Type*) [TopologicalSpace X] :
    CountableChainCondition X ↔ ∀ ⦃S : Set (Set X)⦄,
      S.PairwiseDisjoint id → (∀ s ∈ S, IsOpen s) → ∅ ∉ S → S.Countable := by
  refine ⟨fun h S Sd So _ ↦ h.countable_chain_condition Sd So, fun h ↦ ?_⟩
  refine { countable_chain_condition := fun S Sd So ↦ ?_ }
  apply Set.countable_of_setminus_singleton (a := ∅)
  apply h (PairwiseDisjoint.subset Sd sdiff_subset) fun _ h ↦ So _ h.1
  simp

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.countableChainCondition : WellDefined CountableChainCondition :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    refine ⟨fun {S} hDisj hOpen => ?_⟩
    have hSurj : Surjective φ := φ.surjective
    have hPreInj : Injective (Set.preimage φ) :=
      (Set.preimage_injective).mpr hSurj
    let T := (Set.preimage φ) '' S
    have hT_disj : T.PairwiseDisjoint id := by
      intro t1 ht1 t2 ht2 hne
      rcases ht1 with ⟨s1, hs1, rfl⟩
      rcases ht2 with ⟨s2, hs2, rfl⟩
      have hs_ne : s1 ≠ s2 := fun heq => hne (by rw [heq])
      exact Disjoint.preimage _ (hDisj hs1 hs2 hs_ne)
    have hT_open : ∀ t ∈ T, IsOpen t := by
      intro t ht
      rcases ht with ⟨s, hs, rfl⟩
      exact φ.isOpen_preimage.mpr (hOpen s hs)
    have hT_countable : T.Countable :=
      h.countable_chain_condition hT_disj hT_open
    exact Set.countable_of_injective_of_countable_image hPreInj.injOn hT_countable

end PiBase

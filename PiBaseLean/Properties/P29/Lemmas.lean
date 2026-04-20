module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P29.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

lemma Set.countable_of_setminus_singleton {α : Type*} {s : Set α} {a : α}
    (h : (s \ {a}).Countable) : s.Countable :=
  Countable.of_diff h <| countable_singleton a

theorem countableChainCondition_iff_ex_nonempty_chain (X : Type*) [TopologicalSpace X] :
    CountableChainCondition X ↔ ∀ ⦃S : Set (Set X)⦄,
      S.PairwiseDisjoint id → (∀ s ∈ S, IsOpen s) → ∅ ∉ S → S.Countable := by
  refine ⟨fun h S Sd So _ ↦ h.countable_chain_condition Sd So, fun h ↦ ?_⟩
  refine { countable_chain_condition := fun S Sd So ↦ ?_ }
  apply Set.countable_of_setminus_singleton (a := ∅)
  apply h (PairwiseDisjoint.subset Sd diff_subset) fun _ h ↦ So _ h.1
  simp

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.countableChainCondition : WellDefined CountableChainCondition :=
  sorry

end Meta

end PiBase

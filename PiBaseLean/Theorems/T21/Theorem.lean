module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P26.Lemmas
public import PiBaseLean.Properties.P29.Lemmas

@[expose] public section

universe u

open Topology Set Function TopologicalSpace

namespace PiBase

--proof can probably be golfed a lot
/-- Theorem T21: P26 (SeparableSpace) => P29 (CountableChainCondition) -/
instance instCountableChainConditionOfSeparableSpace (X : Type u)
    [TopologicalSpace X] [h : SeparableSpace X] : CountableChainCondition X := by
  refine (countableChainCondition_iff_ex_nonempty_chain X).mpr (fun S Sd So Sn ↦ ?_)
  obtain ⟨r, rc, dr⟩ := h.exists_countable_dense
  by_contra h0
  have : ∃ i ∈ S, Disjoint i r := by
    contrapose! h0
    rw [← countable_coe_iff] at rc ⊢
    let f : S → r := fun ⟨i, iS⟩ ↦
      letI hi := not_disjoint_iff_nonempty_inter.1 (h0 i iS)
      ⟨hi.choose, mem_of_mem_inter_right hi.choose_spec⟩
    apply Injective.countable (f := f)
    intro ⟨a, ha⟩ ⟨b, hb⟩ ab
    simp only [Subtype.mk.injEq]
    have (u : S) : (f u).val ∈ u.val :=
      mem_of_mem_inter_left (not_disjoint_iff_nonempty_inter.1 (h0 u.val u.prop)).choose_spec
    have ha' := this ⟨a, ha⟩
    have hb' := this ⟨b, hb⟩
    by_contra! h1
    have := disjoint_of_subset_left (fun ⦃a_1⦄ a ↦ a) <| Sd ha hb h1
    contrapose! this
    apply not_disjoint_iff_nonempty_inter.mpr
    refine ⟨f ⟨a, ha⟩, ?_⟩
    simp_all
  obtain ⟨i, iS, ri⟩ := this
  have iN : i.Nonempty := by
    contrapose! Sn
    rwa [← Sn]
  exact Set.not_disjoint_iff_nonempty_inter.mpr (dense_iff_inter_open.mp dr i (So i iS) iN) ri

end PiBase

namespace PiBase.Formal

theorem T21 : P26 ≤ P29 := fun X _ ↦ @instCountableChainConditionOfSeparableSpace X _

end PiBase.Formal

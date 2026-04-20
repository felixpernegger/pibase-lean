module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P39.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem isPreirreducible_iff_subset_closure_inter_open (S : Set X) :
    IsPreirreducible S ↔
      (∀ U : Set X, IsOpen U → (S ∩ U).Nonempty → S ⊆ closure (S ∩ U)) := by
  refine ⟨fun h _ ↦ ?_, fun h ↦ ?_⟩
  · exact subset_closure_inter_of_isPreirreducible_of_isOpen h
  · intro a b ha hb aS bS
    have ha' := h a ha aS
    have hb' := h b hb bS
    by_contra! h0
    obtain ⟨p, pS, pa⟩ := aS
    suffices p ∉ closure (S ∩ b) from this <| hb' pS
    simp only [closure, mem_sInter, mem_setOf_eq, and_imp, not_forall, exists_prop]
    refine ⟨aᶜ, by simpa, ?_, ?_⟩
    · apply subset_compl_iff_disjoint_left.mpr
      apply disjoint_iff_inter_eq_empty.mpr
      grind
    · simpa

theorem preirreducibleSpace_iff_open_dense (X : Type*) [TopologicalSpace X] :
    PreirreducibleSpace X ↔ ∀ ⦃U : Set X⦄, IsOpen U → U.Nonempty → Dense U := by
  have : PreirreducibleSpace X ↔ IsPreirreducible (@univ X) :=
    ⟨fun h ↦ PreirreducibleSpace.isPreirreducible_univ, fun h ↦ { isPreirreducible_univ := h }⟩
  rw [this, isPreirreducible_iff_subset_closure_inter_open]
  simp only [univ_inter, univ_subset_iff, Dense]
  grind

section Meta

theorem WellDefined.preirreducibleSpace : WellDefined PreirreducibleSpace :=
  sorry

end Meta

end PiBase

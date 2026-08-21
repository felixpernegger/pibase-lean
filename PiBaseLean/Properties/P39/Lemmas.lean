module

public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

namespace PiBase

open Set

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
    simp only [closure, mem_sInter, mem_ofPred_eq, and_imp, not_forall, exists_prop]
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

theorem Homeomorph.preirreducibleSpace [PreirreducibleSpace X] (f : X ≃ₜ Y) :
    PreirreducibleSpace Y :=
  f.surjective.preirreducibleSpace f.continuous

theorem WellDefined.preirreducibleSpace : WellDefined PreirreducibleSpace :=
  fun {_ _} _ _ h _ => Homeomorph.preirreducibleSpace h.some

end PiBase

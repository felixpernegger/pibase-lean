module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P198.Defs

import Mathlib.Tactic.Order

@[expose] public section

namespace PiBase

open Set Cardinal

variable (X Y : Type*) [TopologicalSpace X] [TopologicalSpace Y]

/-- A space has countable extent iff all discrete closed subsets are countable. -/
theorem hasCountableExtent_iff_discrete_countable :
    HasCountableExtent X ↔ ∀ ⦃s : Set X⦄, IsDiscrete s → IsClosed s → s.Countable := by
  refine ⟨fun h s hs sc ↦ ?_, fun h ↦ ?_⟩
  · have := h.extent_eq
    by_contra h0
    suffices ℵ₀ < Extent X by order
    unfold Extent
    calc
      _ < sSup {t | ∃ D : Set X, #↑D = t ∧ IsClosed D ∧ IsDiscrete D} := by
          refine (lt_csSup_iff ?_ ?_).mpr ?_
          · exact bddAbove_extent X
          · exact ⟨0, ∅, by simp [DiscreteTopology.isDiscrete]⟩
          · simp only [mem_ofPred_eq, ↓existsAndEq, true_and]
            refine ⟨s, ⟨sc, hs⟩, ?_⟩
            contrapose! h0
            exact le_aleph0_iff_set_countable.mp h0
       _ ≤ Extent X := self_le_add_right _ _
  · apply HasCountableExtent.mk
    apply le_antisymm ?_ (aleph_zero_le_extent X)
    unfold Extent
    simp only [add_le_aleph0, Std.le_refl, and_true]
    refine csSup_le' ?_
    simp only [upperBounds, mem_ofPred_eq, forall_exists_index, and_imp]
    exact fun a s sa sc sd ↦ sa ▸ le_aleph0_iff_set_countable.mpr (h sd sc)

universe u

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

private lemma isDiscrete_image_homeomorph {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]
    (φ : X ≃ₜ Y) {s : Set X} (hs : IsDiscrete s) : IsDiscrete (φ '' s) := by
  have hDT : DiscreteTopology s := isDiscrete_iff_discreteTopology.mp hs
  have hDT' : DiscreteTopology (φ '' s) := by
    have := hDT
    exact (φ.image s).discreteTopology
  exact isDiscrete_iff_discreteTopology.mpr hDT'

private lemma isDiscrete_preimage_homeomorph {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]
    (φ : X ≃ₜ Y) {t : Set Y} (ht : IsDiscrete t) : IsDiscrete (φ ⁻¹' t) := by
  have h_eq : φ ⁻¹' t = φ.symm '' t := by
    ext x
    constructor
    · intro hx
      exact ⟨φ x, hx, by simp⟩
    · rintro ⟨y, hy, rfl⟩
      simp [hy]
  rw [h_eq]
  exact isDiscrete_image_homeomorph φ.symm ht

theorem WellDefined.hasCountableExtent : WellDefined HasCountableExtent :=
  fun {X Y} _ _ hXY h => by
    let φ := hXY.some
    rcases h with ⟨h_eq_X⟩
    have hDiscImage : ∀ {s : Set _} (_ : IsDiscrete s), IsDiscrete (φ '' s) := by
      intro s hs
      have hDT : DiscreteTopology s := isDiscrete_iff_discreteTopology.mp hs
      have hDT' : DiscreteTopology (φ '' s) := by
        have := hDT
        exact (φ.image s).discreteTopology
      exact isDiscrete_iff_discreteTopology.mpr hDT'
    have hDiscPre : ∀ {t : Set _} (_ : IsDiscrete t), IsDiscrete (φ ⁻¹' t) := by
      intro t ht
      have h_pre_eq : φ ⁻¹' t = φ.symm '' t := by
        ext x
        constructor
        · intro hx
          exact ⟨φ x, hx, by simp⟩
        · rintro ⟨y, hy, rfl⟩
          simp [hy]
      rw [h_pre_eq]
      have hDT : DiscreteTopology t := isDiscrete_iff_discreteTopology.mp ht
      have hDT' : DiscreteTopology (φ.symm '' t) := by
        have := hDT
        exact (φ.symm.image t).discreteTopology
      exact isDiscrete_iff_discreteTopology.mpr hDT'
    have hExtent_eq : Extent X = Extent Y := by
      unfold Extent
      congr 1
      apply congrArg sSup
      ext c
      constructor
      · rintro ⟨D, hDc, hCl, hDisc⟩
        exact ⟨φ '' D, by rw [mk_image_eq φ.injective, hDc], φ.isClosed_image.mpr hCl,
          hDiscImage hDisc⟩
      · rintro ⟨D, hDc, hCl, hDisc⟩
        have hDisc' : IsDiscrete (φ ⁻¹' D) := hDiscPre hDisc
        have hCl' : IsClosed (φ ⁻¹' D) := φ.isClosed_preimage.mpr hCl
        have hCard : #(φ ⁻¹' D) = #D := by
          have h_eq : φ ⁻¹' D = φ.symm '' D := by
            ext x
            constructor
            · intro hx
              exact ⟨φ x, hx, by simp⟩
            · rintro ⟨y, hy, rfl⟩
              simp [hy]
          rw [h_eq, mk_image_eq φ.symm.injective]
        exact ⟨φ ⁻¹' D, by rw [hCard, hDc], hCl', hDisc'⟩
    constructor
    calc
      Extent Y = Extent X := hExtent_eq.symm
      _ = ℵ₀ := h_eq_X

end PiBase

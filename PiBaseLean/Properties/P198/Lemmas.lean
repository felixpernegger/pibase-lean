module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P198.Defs
public import Mathlib.Topology.Homeomorph.Lemmas
public import Mathlib.Topology.DiscreteSubset
public import Mathlib.Data.Set.Countable

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace Cardinal

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

section Meta

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
  fun {_ _} _ _ h hX => Formal.P198.well_defined h.some hX

end Meta

end PiBase

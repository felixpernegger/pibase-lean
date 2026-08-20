module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P197.Defs
public import Mathlib.Topology.Homeomorph.Lemmas
public import Mathlib.Topology.DiscreteSubset
public import Mathlib.Data.Set.Countable

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace Cardinal

variable (X Y : Type*) [TopologicalSpace X] [TopologicalSpace Y]

/-- A space has countable spread iff all discrete closed subsets are countable. -/
theorem hasCountableSpread_iff_discrete_countable :
    HasCountableSpread X ↔ ∀ ⦃s : Set X⦄, IsDiscrete s → s.Countable := by
  refine ⟨fun h s hs ↦ ?_, fun h ↦ ?_⟩
  · have := h.spread_eq
    by_contra h0
    suffices ℵ₀ < Spread X by order
    unfold Spread
    calc
      _ < sSup {t | ∃ D : Set X, #↑D = t ∧ IsDiscrete D} := by
          refine (lt_csSup_iff ?_ ?_).mpr ?_
          · exact bddAbove_spread X
          · exact ⟨0, ∅, by simp [DiscreteTopology.isDiscrete]⟩
          · simp only [mem_ofPred_eq, ↓existsAndEq, true_and]
            refine ⟨s, hs, ?_⟩
            contrapose! h0
            exact le_aleph0_iff_set_countable.mp h0
       _ ≤ Spread X := self_le_add_right _ _
  · apply HasCountableSpread.mk
    apply le_antisymm ?_ (aleph_zero_le_spread X)
    unfold Spread
    simp only [add_le_aleph0, Std.le_refl, and_true]
    refine csSup_le' ?_
    simp only [upperBounds, mem_ofPred_eq, forall_exists_index, and_imp]
    exact fun a s sa sd ↦ sa ▸ le_aleph0_iff_set_countable.mpr (h sd)

universe u

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

/-- Discrete subsets are preserved by homeomorphic images via the subtype homeomorph `φ.image`. -/
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

theorem WellDefined.hasCountableSpread : WellDefined HasCountableSpread :=
  fun {X Y} _ _ hXY h => by
    let φ := hXY.some
    rcases h with ⟨h_eq_X⟩
    -- discrete preserved by homeomorphic image via φ.image : s ≃ₜ φ '' s
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
    have hSpread_eq : Spread X = Spread Y := by
      unfold Spread
      congr 1
      apply congrArg sSup
      ext c
      constructor
      · rintro ⟨D, hDc, hDisc⟩
        exact ⟨φ '' D, by rw [mk_image_eq φ.injective, hDc], hDiscImage hDisc⟩
      · rintro ⟨D, hDc, hDisc⟩
        have hDisc' : IsDiscrete (φ ⁻¹' D) := hDiscPre hDisc
        have hCard : #(φ ⁻¹' D) = #D := by
          have h_eq : φ ⁻¹' D = φ.symm '' D := by
            ext x
            constructor
            · intro hx
              exact ⟨φ x, hx, by simp⟩
            · rintro ⟨y, hy, rfl⟩
              simp [hy]
          rw [h_eq, mk_image_eq φ.symm.injective]
        exact ⟨φ ⁻¹' D, by rw [hCard, hDc], hDisc'⟩
    -- hSpread_eq shows Spread X = Spread Y, so ℵ₀ is preserved
    constructor
    calc
      Spread Y = Spread X := hSpread_eq.symm
      _ = ℵ₀ := h_eq_X

end Meta

end PiBase

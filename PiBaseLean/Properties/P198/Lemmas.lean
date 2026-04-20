module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P198.Defs

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
          · exact ⟨_, upperBounds_extent X⟩
          · exact ⟨0, ∅, by simp [DiscreteTopology.isDiscrete]⟩
          · simp only [mem_setOf_eq, ↓existsAndEq, true_and]
            refine ⟨s, ⟨sc, hs⟩, ?_⟩
            contrapose! h0
            exact le_aleph0_iff_set_countable.mp h0
       _ ≤ Extent X := self_le_add_right _ _
  · apply HasCountableExtent.mk
    apply le_antisymm ?_ (aleph_zero_le_extent X)
    unfold Extent
    simp only [add_le_aleph0, Std.le_refl, and_true]
    refine csSup_le' ?_
    simp only [upperBounds, mem_setOf_eq, forall_exists_index, and_imp]
    exact fun a s sa sc sd ↦ sa ▸ le_aleph0_iff_set_countable.mpr (h sd sc)

section Meta

theorem WellDefined.hasCountableExtent : WellDefined HasCountableExtent :=
  sorry

end Meta

end PiBase

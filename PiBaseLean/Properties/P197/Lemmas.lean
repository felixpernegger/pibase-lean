module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P197.Defs

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
          · exact ⟨_, upperBounds_spread X⟩
          · exact ⟨0, ∅, by simp [DiscreteTopology.isDiscrete]⟩
          · simp only [mem_setOf_eq, ↓existsAndEq, true_and]
            refine ⟨s, hs, ?_⟩
            contrapose! h0
            exact le_aleph0_iff_set_countable.mp h0
       _ ≤ Spread X := self_le_add_right _ _
  · apply HasCountableSpread.mk
    apply le_antisymm ?_ (aleph_zero_le_spread X)
    unfold Spread
    simp only [add_le_aleph0, Std.le_refl, and_true]
    refine csSup_le' ?_
    simp only [upperBounds, mem_setOf_eq, forall_exists_index, and_imp]
    exact fun a s sa sd ↦ sa ▸ le_aleph0_iff_set_countable.mpr (h sd)

section Meta

theorem WellDefined.hasCountableSpread : WellDefined HasCountableSpread :=
  sorry

end Meta

end PiBase

module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P129.Defs

@[expose] public section

namespace PiBase

universe u

open Topology Filter Set Function TopologicalSpace

section Meta

--to mathlib
/-- A space is indiscrete iff all open sets are either the empty space or the entire space. -/
theorem TopologicalSpace.indiscrete_iff_isOpen_iff_empty_or_univ
    (X : Type u) [TopologicalSpace X] :
    IndiscreteTopology X ↔ ∀ U : Set X, IsOpen U ↔ (U = ∅ ∨ U = univ) := by
  refine ⟨fun _ U ↦ IndiscreteTopology.isOpen_iff U, fun _ ↦ ?_⟩
  apply IndiscreteTopology.of_forall_inseparable (fun _ _ ↦ ?_)
  exact inseparable_iff_forall_isOpen.mpr (fun _ _ ↦ by grind)

--to mathlib
/-- Every topological space is as least as fine as the indiscrete topology. -/
@[simp]
theorem TopologicalSpace.le_top (X : Type u) [τ : TopologicalSpace X] :
    τ ≤ ⊤ := by
  apply TopologicalSpace.le_def.mpr (fun a ha ↦ ?_)
  rw [IndiscreteTopology.isOpen_iff] at ha
  rcases ha with h|h <;> simp [h]

--to mathlib
/-- Every topological space is as least as coarse as the indiscrete topology. -/
@[simp]
theorem TopologicalSpace.bot_le (X : Type u) [τ : TopologicalSpace X] :
    ⊥ ≤ τ := TopologicalSpace.le_def.mpr fun _ _ ↦ trivial

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.indiscreteTopology : WellDefined IndiscreteTopology :=
  sorry

end Meta

end PiBase

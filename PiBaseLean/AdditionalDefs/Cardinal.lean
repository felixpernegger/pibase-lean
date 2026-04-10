module

public import Mathlib.SetTheory.Cardinal.Order
public import Mathlib.Topology.Constructions

@[expose] public section

/-! This file contains additional set theoretic constructions around topological spaces
which are useful for properties and theorems. -/

universe u

namespace PiBase

namespace AdditionalDefs

open Cardinal Set

variable (X : Type u) [TopologicalSpace X]

/-- Spread of a topological space -/
noncomputable def Spread : Cardinal.{u} :=
  sSup {t : Cardinal.{u} | ∃ D : Set X, #D = t ∧ IsDiscrete D} + ℵ₀

--TODO: golf
/-- The spread is less then the cardinality of the space + ℵ₀. -/
theorem spread_le_card : Spread X ≤ #X + ℵ₀ := by
  unfold Spread
  gcongr
  refine csSup_le' ?_
  simp only [upperBounds, mem_setOf_eq, forall_exists_index, and_imp]
  intro t s st sd
  rw [← st]
  exact mk_set_le s

/-- Spread of a topological space -/
noncomputable def Extent : Cardinal.{u} :=
  sSup {t : Cardinal.{u} | ∃ D : Set X, #D = t ∧ IsClosed D ∧ IsDiscrete D} + ℵ₀

--TODO: golf
/-- The extent of a space is less or equal to the spread. -/
theorem extent_le_spread : Extent X ≤ Spread X := by
  unfold Extent Spread
  gcongr 3 with t
  · refine ⟨#X, ?_⟩
    simp only [upperBounds, mem_setOf_eq, forall_exists_index, and_imp]
    intro t s st sd
    rw [← st]
    exact mk_set_le s
  intro ⟨D, Dt, _, Dd⟩
  exact ⟨D, Dt, Dd⟩

/-- The extent of a space is at least ℵ₀. -/
theorem aleph_zero_le_extent : ℵ₀ ≤ Extent X := self_le_add_left _ _

/-- The spread of a space is at least ℵ₀. -/
theorem aleph_zero_le_spread : ℵ₀ ≤ Spread X := self_le_add_left _ _

end AdditionalDefs

end PiBase

module

public import Mathlib

@[expose] public section

/-! This file contains additional set theoretic constructions around topological spaces
which are useful for properties and theorems. -/

universe u

namespace PiBase

open Cardinal Set Filter Topology

variable (X : Type u) [TopologicalSpace X]

/-- Spread of a topological space -/
noncomputable def Spread : Cardinal.{u} :=
  sSup {t : Cardinal.{u} | ∃ D : Set X, #D = t ∧ IsDiscrete D} + ℵ₀

lemma bddAbove_spread : BddAbove {t : Cardinal.{u} | ∃ D : Set X, #D = t ∧ IsDiscrete D} := by
  use #X
  simp only [upperBounds, mem_setOf_eq, forall_exists_index, and_imp]
  exact fun a x xa _ ↦ xa ▸ mk_set_le x

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

lemma bddAbove_extent :
    BddAbove {t : Cardinal.{u} | ∃ D : Set X, #D = t ∧ IsClosed D ∧ IsDiscrete D} := by
  use #X
  simp only [upperBounds, mem_setOf_eq, forall_exists_index, and_imp]
  exact fun a x xa _ _ ↦ xa ▸ mk_set_le x

--TODO: golf
/-- The extent of a space is less or equal to the spread. -/
theorem extent_le_spread : Extent X ≤ Spread X := by
  unfold Extent Spread
  gcongr 3 with t
  · refine ⟨#X, ?_⟩
    simp only [upperBounds, mem_setOf_eq, forall_exists_index, and_imp]
    exact fun t s st sd ↦ st ▸ mk_set_le s
  exact fun ⟨D, Dt, _, Dd⟩ ↦ ⟨D, Dt, Dd⟩

/-- The extent of a space is at least ℵ₀. -/
theorem aleph_zero_le_extent : ℵ₀ ≤ Extent X := self_le_add_left _ _

/-- The spread of a space is at least ℵ₀. -/
theorem aleph_zero_le_spread : ℵ₀ ≤ Spread X := self_le_add_left _ _

/-- A *radially closed* set is a set such that all limits of transfinite of sequences in the set lie
in the set themselves -/
def IsRadiallyClosed {X : Type u} [TopologicalSpace X] (s : Set X) : Prop :=
  ∀ x : X, (∃ (s : Ordinal.{u}) (f : Iio s → X), Tendsto f atTop (𝓝 x)) → x ∈ s

--TODO: limit of transfinite sequence must lie in closure

/-- A type `α` is denumerable iff `univ : Set α` is denumerable. -/
lemma Denumerable.Set.univ (α : Type u) :
    Nonempty (Denumerable α) ↔ Nonempty (Denumerable (@univ α)) := by
  refine ⟨fun h ↦ ?_, fun h ↦ ?_⟩
  · have := h.some
    exact Nonempty.intro <| Denumerable.ofEquiv α <| Equiv.Set.univ α
  · have := h.some
    exact Nonempty.intro <| Denumerable.ofEquiv _ <| (Equiv.Set.univ α).symm

/-- If `α : Type u` is countable, it is bijective to some countable `r : Type`. -/
theorem countable_equiv_type (α : Type u) [h : Countable α] :
    ∃ (ι : Type) (_ : α ≃ ι), Countable ι := by
  by_cases! f : Finite α
  · obtain ⟨n, hn⟩ := finite_iff_exists_equiv_fin.mp f
    refine ⟨Fin n, ?_⟩
    rw [exists_const]
    infer_instance
  let : Nonempty (Denumerable α) := by
    rw [nonempty_denumerable_iff]
    exact ⟨h, f⟩
  have := this.some
  exact ⟨ℕ, Denumerable.equiv₂ α ℕ, instCountableNat⟩

end PiBase

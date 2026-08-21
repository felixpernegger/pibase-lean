module

public import Mathlib.SetTheory.Ordinal.Arithmetic
public import Mathlib.Topology.Sequences

/-! This file contains additional set theoretic constructions around topological spaces
which are useful for properties and theorems. -/

@[expose] public section

universe u

namespace PiBase

open Cardinal Set Filter Topology Ordinal

variable (X : Type u) [TopologicalSpace X]

/-- Spread of a topological space -/
noncomputable def Spread : Cardinal.{u} :=
  sSup {t : Cardinal.{u} | ∃ D : Set X, #D = t ∧ IsDiscrete D} + ℵ₀

lemma upperBounds_spread :
    #X ∈ upperBounds {t : Cardinal.{u} | ∃ D : Set X, #D = t ∧ IsDiscrete D} := by
  simp only [upperBounds, mem_ofPred_eq, forall_exists_index, and_imp]
  exact fun a x xa _ ↦ xa ▸ mk_set_le x

lemma bddAbove_spread : BddAbove {t : Cardinal.{u} | ∃ D : Set X, #D = t ∧ IsDiscrete D} :=
  ⟨_, upperBounds_spread X⟩

/-- The spread is less then the cardinality of the space + ℵ₀. -/
theorem spread_le_card : Spread X ≤ #X + ℵ₀ := by
  unfold Spread
  gcongr
  exact csSup_le' (upperBounds_spread X)

/-- Spread of a topological space -/
noncomputable def Extent : Cardinal.{u} :=
  sSup {t : Cardinal.{u} | ∃ D : Set X, #D = t ∧ IsClosed D ∧ IsDiscrete D} + ℵ₀

lemma upperBounds_extent :
    #X ∈ upperBounds {t : Cardinal.{u} | ∃ D : Set X, #D = t ∧ IsClosed D ∧ IsDiscrete D} := by
  simp only [upperBounds, mem_ofPred_eq, forall_exists_index, and_imp]
  exact fun a x xa _ _ ↦ xa ▸ mk_set_le x

lemma bddAbove_extent :
    BddAbove {t : Cardinal.{u} | ∃ D : Set X, #D = t ∧ IsClosed D ∧ IsDiscrete D} :=
  ⟨_, upperBounds_extent X⟩

/-- The extent of a space is less or equal to the spread. -/
theorem extent_le_spread : Extent X ≤ Spread X := by
  unfold Extent Spread
  gcongr 3 with t
  · exact bddAbove_spread X
  exact fun ⟨D, Dt, _, Dd⟩ ↦ ⟨D, Dt, Dd⟩

/-- The extent of a space is at least ℵ₀. -/
theorem aleph_zero_le_extent : ℵ₀ ≤ Extent X := self_le_add_left _ _

/-- The spread of a space is at least ℵ₀. -/
theorem aleph_zero_le_spread : ℵ₀ ≤ Spread X := self_le_add_left _ _

/-- A *radially closed* set is a set such that all limits of transfinite of sequences in the set lie
in the set themselves -/
def IsRadiallyClosed {X : Type u} [TopologicalSpace X] (s : Set X) : Prop :=
  ∀ x : X, (∃ (o : Ordinal.{u}) (f : Iio o → X), 0 < o ∧ range f ⊆ s ∧ Tendsto f atTop (𝓝 x)) →
    x ∈ s

variable {X}

/-- The radial closure of a set. -/
def radialClosure (s : Set X) : Set X :=
  { x | ∃ (o : Ordinal.{u}) (f : Iio o → X), 0 < o ∧ range f ⊆ s ∧ Tendsto f atTop (𝓝 x) }

theorem seqClosure_subset_radialClosure {s : Set X} :
    seqClosure s ⊆ radialClosure s := by
  intro a ⟨l, l_mem, hl⟩
  let e : Iio (ω : Ordinal.{u}) → ℕ :=
    fun a ↦ ((Ordinal.lt_omega0).mp a.2).choose
  have e_id (n : ℕ) : e ⟨n, by simp⟩ = n := by
    set u := (⟨n, by simp⟩ : Iio (ω : Ordinal.{u}))
    have eo : e u = u.val := by
      unfold e
      exact (((Ordinal.lt_omega0).mp u.2).choose_spec).symm
    have et : n = u.val := by
      simp [u]
    rwa [← et, Nat.cast_inj] at eo
  refine ⟨ω, l ∘ e, ?_, ?_, ?_⟩
  · simp
  · apply subset_trans (range_comp_subset_range e l)
    intro e ⟨n, hn⟩
    rw [← hn]
    exact l_mem n
  · have : Nonempty (Iio ω) := ⟨0, by simp⟩
    rw [tendsto_atTop_nhds] at hl ⊢
    intro U aU hU
    obtain ⟨N, hN⟩ := hl U aU hU
    refine ⟨⟨N, by simp⟩, ?_⟩
    intro a Na
    rw [Function.comp_apply]
    apply hN
    simp only [e]
    contrapose! Na
    apply Subtype.coe_lt_coe.mp
    simp only
    obtain ⟨r, hr⟩ := lt_omega0.mp a.property
    rw [hr]
    simp only [Nat.cast_lt]
    have : (lt_omega0.mp a.property).choose = r := by
      have := (lt_omega0.mp a.property).choose_spec
      set u := (lt_omega0.mp a.property).choose
      rw [this] at hr
      simp_all
    rwa [this] at Na

theorem subset_radialClosure (s : Set X) : s ⊆ radialClosure s :=
  subset_trans subset_seqClosure seqClosure_subset_radialClosure

theorem isRadiallyClosed_iff_radialClosure_eq (s : Set X) :
    IsRadiallyClosed s ↔ radialClosure s = s := by
  unfold IsRadiallyClosed
  refine ⟨fun h ↦ ?_, fun h ↦ ?_⟩
  · apply le_antisymm
    · exact h
    · exact subset_radialClosure s
  have : radialClosure s ⊆ s := by
    rw [h]
  exact this

theorem ordinal_tendsto_closure {X : Type u} [TopologicalSpace X] {s : Set X} :
    radialClosure s ⊆ closure s := by
  intro a ha
  by_contra h0
  unfold radialClosure at ha
  obtain ⟨o, f, op, fs, hf⟩ := ha
  have : Nonempty (Iio o) := by
    use 0
    simpa
  rw [tendsto_atTop_nhds] at hf
  obtain ⟨N, hN⟩ := hf (closure s)ᶜ (by simpa) (by simp)
  apply hN N (le_refl N)
  apply mem_of_subset_of_mem subset_closure
  apply fs
  simp

/-- A type `α` is denumerable iff `univ : Set α` is denumerable. -/
lemma Denumerable.Set.univ (α : Type u) :
    Nonempty (Denumerable α) ↔ Nonempty (Denumerable (@univ α)) :=
  ⟨.map fun _ ↦ .ofEquiv _ (Equiv.Set.univ α), .map fun _ ↦ .ofEquiv _ ((Equiv.Set.univ α).symm)⟩

/-- If `α : Type u` is countable, it is bijective to some countable `r : Type`. -/
theorem countable_equiv_type (α : Type u) [h : Countable α] :
    ∃ (ι : Type) (_ : α ≃ ι), Countable ι := by
  rcases Small.equiv_small.{0} (α := α) with ⟨ι, ⟨φ⟩⟩
  refine ⟨ι, φ, .of_equiv α φ⟩

section

open Classical in
noncomputable local instance : SupSet (Fin 2) where
  sSup s := if 1 ∈ s then 1 else 0

def KAdditive {k : Cardinal.{u}} (f : Set (Iio k) → Fin 2) : Prop :=
  ∀ (A : Set (Set (Iio k))), (#A < Cardinal.lift.{u + 1, u} k) →
    (∀ᵉ (i ∈ A) (j ∈ A), i ≠ j → Disjoint i j) →
      f (sUnion A) = 1 ↔ ∃! s ∈ A, f s = 1

def IsMeasurable (k : Cardinal.{u}) := ℵ₀ < k ∧ ∃ f : Set (Iio k) → Fin 2, KAdditive f ∧
  (∀ a : Iio k, f {a} = 0) ∧ (∃ a : Set (Iio k), f a ≠ 0) ∧ ∀ a : Set (Iio k), f a ≤ 1

end

end PiBase

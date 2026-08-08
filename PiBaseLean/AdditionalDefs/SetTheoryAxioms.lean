module

public import Mathlib.Data.Real.Basic
public import Mathlib.SetTheory.Cardinal.Continuum

import Mathlib.Analysis.Real.Cardinality

/-!
# Set theory axioms beyond ZFC

Some implications between topological properties are consistent under ZFC, but not provable
etc (i.e. Continuum < 𝔠 → Continuum < ℵ₁).

We still want to be able to argue about such pathological examples. Thus, this file introduces three
typeclasses for common set theoretic axioms (CH, GCH and MA) and proves implications about them.

Note that it is not possible in Lean to define some sort of `Unprovable : Prop → Prop`; to do this
one would need to model first order logic (or some other foundation) within Lean;
this has been done before [here](https://flypitch.github.io/).

Some code in this file is due to Eric Wieser, in particular from https://github.com/leanprover-community/mathlib4/pull/34075.

-/

@[expose] public section

open Cardinal Ordinal

section ContinuumHypothesis

/-- The statement that the continuum hypothesis holds.

To avoid a universe parameter, we only state that this holds in universe `0`, since it can be lifted
to other universes with subsequent theorems.

See `ContinuumHypothesis.iff_aleph0_covby_continuum` and
`ContinuumHypothesis.iff_continuum_eq_aleph_one` for typical characterizations.
-/
@[mk_iff ContinuumHypothesis.iff_continuum_eq_aleph_one']
class ContinuumHypothesis where
  /-- See `ContinuumHypothesis.of_continuum_eq_aleph_one'` for the universe-generic version. -/
  private of_continuum_eq_aleph_one' ::
  /-- See `ContinuumHypothesis.continuum_eq_aleph_one` for the universe-generic version. -/
  private continuum_eq_aleph_one' : (𝔠 : Cardinal.{0}) = ℵ₁

namespace ContinuumHypothesis

section basic_constructors

theorem iff_continuum_eq_aleph_one.{u} : ContinuumHypothesis ↔ (𝔠 : Cardinal.{u}) = ℵ₁ := by
  rw [iff_continuum_eq_aleph_one', ← Cardinal.lift_continuum.{u, 0}, Cardinal.lift_eq_aleph_one]

@[simp]
theorem continuum_eq_aleph_one.{u} [ContinuumHypothesis] : (𝔠 : Cardinal.{u}) = ℵ₁ :=
  iff_continuum_eq_aleph_one.1 ‹_›

alias ⟨_, of_continuum_eq_aleph_one⟩ := iff_continuum_eq_aleph_one

theorem iff_aleph0_covby_continuum.{u} : ContinuumHypothesis ↔ ℵ₀ ⋖ (𝔠 : Cardinal.{u}) := by
  rw [← Order.succ_eq_iff_covBy, Cardinal.succ_aleph0, eq_comm, iff_continuum_eq_aleph_one]

theorem aleph0_covby_continuum.{u} [ContinuumHypothesis] : ℵ₀ ⋖ (𝔠 : Cardinal.{u}) :=
  iff_aleph0_covby_continuum.1 ‹_›

alias ⟨_, of_aleph0_covby_continuum⟩ := iff_aleph0_covby_continuum

end basic_constructors

end ContinuumHypothesis

end ContinuumHypothesis

section GeneralizedContinuumHypothesis

/-- Staement of the generalized continuum hypothesis.
Note this unfortunately is universe dependent, which is unavoidable. -/
class GeneralizedContinuumHypothesis.{u} where
  succ_cardinal_eq_pow {o : Ordinal.{u}} : ℵ₀ ≤ ℵ_ o → ℵ_ (o + 1) = 2 ^ (ℵ_ o)

instance [h : GeneralizedContinuumHypothesis.{u}] : GeneralizedContinuumHypothesis.{u} where
  succ_cardinal_eq_pow {o} oh := by
    apply Cardinal.lift_injective.{u}
    simp [-Cardinal.lift_id, -Ordinal.lift_id,
      h.succ_cardinal_eq_pow (o := Ordinal.lift.{u} o) (by simpa)]

instance [h : GeneralizedContinuumHypothesis.{0}] : ContinuumHypothesis where
  continuum_eq_aleph_one' := by
    rw [Cardinal.continuum, ← aleph_zero, ← zero_add 1, h.succ_cardinal_eq_pow (o := 0) (by simp)]

end GeneralizedContinuumHypothesis

section MartinAxiom

end MartinAxiom

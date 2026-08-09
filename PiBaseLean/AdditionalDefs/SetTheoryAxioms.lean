module

public import Mathlib.Data.Real.Basic
public import Mathlib.SetTheory.Cardinal.Continuum
public import Mathlib.Analysis.Real.Cardinality
public import Mathlib.Order.SetNotation
public import Mathlib.Topology.Baire.LocallyCompactRegular
public import Mathlib.Topology.UnitInterval
public import PiBaseLean.Properties.P29.Defs
public import PiBaseLean.Theorems.T21.Theorem

/-!
# Set theory axioms beyond ZFC

Some implications between topological properties are consistent under ZFC, but not provable
etc (i.e. Cardinality < 𝔠 → Cardinality < ℵ₁).

We still want to be able to argue about such pathological examples. Thus, this file introduces three
typeclasses for common set theoretic axioms (CH, GCH and MA) and proves implications about them.

Note that it is not possible in Lean to define some sort of `Unprovable : Prop → Prop`; to do this
one would need to model first order logic (or some other foundation) within Lean;
this has been done before for example [here](https://flypitch.github.io/).

Some code in this file is due to Eric Wieser, in particular from https://github.com/leanprover-community/mathlib4/pull/34075.

# Main declarations

* `ContinuumHypothesis`: Typeclass for the (positive answer to the) continuum hypothesis.
* `NotContinuumHypothesis`: Typeclass for the negation of the continuum hypothesis.
* `GeneralizedContinuumHypothesis`: Typeclass for the eneralized continuum hypothesis.
* `MartinsAxiom`: Typeclass for Martin's axiom.
* `instMartinsAxiomOfContinuumHypothesis`: The continuum hypothesis implies Martin's axiom.

# How to use

When writing some statement in Lean that holds in ZFC + `n` inacessible cardinals where `n < ℵ₀`,
no assumption on the continuum hypothesis or other axioms should be included.

In some cases however, certain constructions or implications only work under additional assumpions.
In this case, use the typeclasses given, i.e. for some theorem that is (only) true under the
continuum hypothesis, add `[ContinuumHypothesis]` as an argument.

Since Martin's axiom is implied by the continuum hypothesis, right now following combinations are
allowed (consistent w.r.t. ZFC):

* `[MartinsAxiom]`
* `[NotContinuumHypothesis]`
* `[MartinsAxiom], [NotContinuumHypothesis]`
* `[ContinuumHypothesis]`
* `[GeneralizedContinuumHypothesis]`

Both including `ContinuumHypothesis` and `NotContinuumHypothesis` for instance let's us prove false
and thus ought to be never done.

Again, extra axiom assumptions should only be added when it is truly necessary.

-/

@[expose] public section

namespace PiBase

open Cardinal Ordinal Set

section ContinuumHypothesis

/-- The statement that the continuum hypothesis holds.

To avoid a universe parameter, we only state that this holds in universe `0`, since it can be lifted
to other universes with subsequent theorems.

See `ContinuumHypothesis.iff_aleph0_covby_continuum` and
`ContinuumHypothesis.iff_continuum_eq_aleph_one` for typical characterizations.
-/
@[mk_iff ContinuumHypothesis.iff_continuum_eq_aleph_one']
class ContinuumHypothesis where
  /-- See `of_continuum_eq_aleph_one'` for the universe-generic version. -/
  private of_continuum_eq_aleph_one' ::
  /-- See `continuum_eq_aleph_one` for the universe-generic version. -/
  private continuum_eq_aleph_one' : (𝔠 : Cardinal.{0}) = ℵ₁

section basic_constructors

namespace ContinuumHypothesis

theorem iff_continuum_eq_aleph_one.{u} : ContinuumHypothesis ↔ (𝔠 : Cardinal.{u}) = ℵ₁ := by
  rw [ContinuumHypothesis.iff_continuum_eq_aleph_one', ← lift_continuum.{u, 0}, lift_eq_aleph_one]

@[simp]
theorem continuum_eq_aleph_one.{u} [ContinuumHypothesis] : (𝔠 : Cardinal.{u}) = ℵ₁ :=
  iff_continuum_eq_aleph_one.1 ‹_›

alias ⟨_, of_continuum_eq_aleph_one⟩ := iff_continuum_eq_aleph_one

theorem iff_aleph0_covby_continuum.{u} : ContinuumHypothesis ↔ ℵ₀ ⋖ (𝔠 : Cardinal.{u}) := by
  rw [← Order.succ_eq_iff_covBy, Cardinal.succ_aleph0, eq_comm, iff_continuum_eq_aleph_one]

theorem aleph0_covby_continuum.{u} [ContinuumHypothesis] : ℵ₀ ⋖ (𝔠 : Cardinal.{u}) :=
  iff_aleph0_covby_continuum.1 ‹_›

alias ⟨_, of_aleph0_covby_continuum⟩ := iff_aleph0_covby_continuum

end ContinuumHypothesis

end basic_constructors

section negation

@[mk_iff NotContinuumHypothesis.iff_aleph_one_lt_continuum']
class NotContinuumHypothesis : Prop where
  /-- See `of_continuum_eq_aleph_one'` for the universe-generic version. -/
  private of_aleph_one_lt_continuum' ::
  /-- See `continuum_eq_aleph_one` for the universe-generic version. -/
  private aleph_one_lt_continuum' : ℵ₁ < (𝔠 : Cardinal.{0})

namespace NotContinuumHypothesis

theorem iff_aleph_one_lt_continuum.{u} : NotContinuumHypothesis ↔ ℵ₁ < (𝔠 : Cardinal.{u}) := by
  rw [NotContinuumHypothesis.iff_aleph_one_lt_continuum', ← lift_continuum.{u, 0},
    ← lift_lt_continuum]
  simp only [lift_aleph, Ordinal.lift_one, gt_iff_lt, lift_continuum]
  rfl


@[simp]
theorem aleph_one_lt_continuum.{u} [NotContinuumHypothesis] : ℵ₁ < (𝔠 : Cardinal.{u}) :=
  iff_aleph_one_lt_continuum.1 ‹_›

alias ⟨_, of_aleph_one_lt_continuum⟩ := iff_aleph_one_lt_continuum

theorem iff_not_continuumHypothesis : NotContinuumHypothesis ↔ ¬ ContinuumHypothesis := by
  rw [iff_aleph_one_lt_continuum', ContinuumHypothesis.iff_continuum_eq_aleph_one']
  refine ⟨fun h ↦ h.ne.symm, fun h ↦ ?_⟩
  simp [lt_iff_le_and_ne, Ne.symm h, aleph_one_le_continuum]

end NotContinuumHypothesis

end negation

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

/-
Martin's axiom for a cardinal. See https://en.wikipedia.org/wiki/Martin%27s_axiom. We choose a topological definition. -/
def MartinsAxiomFor (k : Cardinal.{u}) : Prop :=
  ∀ᵉ (X : Type u) (_ : TopologicalSpace X) (s : Set (Set X)),
    Nonempty X → T2Space X → CompactSpace X → CountableChainCondition X →
      (∀ a ∈ s, IsNowhereDense a) → Set.sUnion s = Set.univ → k < #s

theorem martinsAxiomFor_of_le {k c : Cardinal.{u}} (h : k ≤ c) (hc : MartinsAxiomFor c) :
    MartinsAxiomFor k := by
  unfold MartinsAxiomFor at hc ⊢
  intro X t s nx t2 cx ccc hs sc
  exact lt_of_le_of_lt h <| hc X t s nx t2 cx ccc hs sc

theorem not_martinsAxiomFor_continuum_bot : ¬ MartinsAxiomFor.{0} 𝔠 := by
  simp only [MartinsAxiomFor, not_forall, not_lt]
  refine ⟨unitInterval, inferInstance, {{i} | i : unitInterval}, inferInstance, inferInstance,
    inferInstance, inferInstance, ?_, ?_, ?_⟩
  · intro a ⟨i, hi⟩
    simp [← hi, IsNowhereDense]
  · ext x
    simp only [Subtype.exists, Set.mem_Icc, Set.mem_sUnion, Set.mem_setOf_eq, ↓existsAndEq,
      Set.mem_singleton_iff, true_and, Set.mem_univ, iff_true]
    grind
  · apply le_of_le_of_eq (b := #unitInterval)
    · apply le_of_eq
      symm
      apply Cardinal.mk_congr
      apply Equiv.ofBijective fun x ↦ ⟨{x}, x, by simp⟩
      refine ⟨?_, ?_⟩
      · intro _
        simp
      · exact fun ⟨_, i, _⟩ ↦ ⟨i, by simp_all⟩
    · --mathlib PR: https://github.com/leanprover-community/mathlib4/pull/42585, replace when it lands
      rw [unitInterval, mk_Icc_real zero_lt_one]

theorem martinsAxiomFor_le_aleph0 {c : Cardinal.{u}} (hc : c ≤ ℵ₀) : MartinsAxiomFor c := by
  apply martinsAxiomFor_of_le hc
  intro X t s ne t2 cx _ hs sc
  by_contra! hsc
  apply not_isMeagre_of_isOpen (X := X) isOpen_univ Set.univ_nonempty
  apply isMeagre_iff_countable_union_isNowhereDense.mpr
  exact ⟨s, hs, le_aleph0_iff_set_countable.mp hsc, sc.ge⟩

@[mk_iff]
class MartinsAxiom : Prop where
  /-- TODO: add universe independent version, similar as we have for CH -/
  martins_axiom_for_lt (k : Cardinal.{0}) : k < 𝔠 → MartinsAxiomFor k

instance instMartinsAxiomOfContinuumHypothesis [h : ContinuumHypothesis] : MartinsAxiom := by
  apply martinsAxiom_iff.mpr
  intro c hc
  rw [h.continuum_eq_aleph_one] at hc
  apply martinsAxiomFor_le_aleph0
  contrapose! hc
  exact aleph0_lt_iff_aleph_one_le.mp hc

end MartinAxiom

end PiBase

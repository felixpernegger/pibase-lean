module

public import PiBaseLean.AdditionalDefs.SetTheoryAxioms
public import PiBaseLean.Bundled.Basic

/-! This file introduces a notiion of some implication being independent of ZFC, but consistent.

-/

@[expose] public section

universe u

namespace PiBase.Formal

/--
A small set of axioms that are independent of ZFC (and Lean's slightly stronger type theory).
This list is critical. Some of them are redudant, but worth including for clarity.

Any change/expansion to it needs to come with a discussion and in particular a reason for
expanding it.

For a justification that this list makes sense, see i.e.

https://math.stackexchange.com/questions/3764313/why-is-ma-not-provable-from-zfc and
https://en.wikipedia.org/wiki/Continuum_hypothesis
-/
def IndependenceSet : Set Prop :=
  {ContinuumHypothesis, NotContinuumHypothesis,
    GeneralizedContinuumHypothesis.{u}, ¬ GeneralizedContinuumHypothesis.{u}, MartinsAxiom,
      ¬ MartinsAxiom, MartinsAxiom ∧ ¬ ContinuumHypothesis}

/-- `P` is independent of ZFC and Lean's type theory.
Note: More precisely, the implication can be proved under some set theory axiom known to be
independent and so does its negation.

A proper, exhaustive and `Prop`-valued notion of independence is likely
not possible to define in Lean. -/
def Independent (P : Prop) : Prop :=
  (∃ A ∈ IndependenceSet.{u}, A → P) ∧
  (∃ B ∈ IndependenceSet.{u}, B → ¬ P)

/-- The implication P → Q is independent of ZFC and Lean's type theory.
Note: More precisely, the implication can be proved under some set theory axiom known to be
independent and so does its negation.

A proper, exhaustive and `Prop`-valued notion of independence is likely
not possible to define in Lean. -/
abbrev IndependentImplication (p q : Property.{u}) :=
  Independent.{u} (p ≤ q)

theorem independent_of_mem_independenceSet {P : Prop} (hP : P ∈ IndependenceSet.{u}) :
    Independent.{u} P := by
  unfold Independent IndependenceSet at *
  exact ⟨by grind, ¬ P, by grind⟩

theorem ContinuumHypothesis.independent : Independent.{u} ContinuumHypothesis := by
  apply independent_of_mem_independenceSet
  simp [IndependenceSet]

theorem NotContinuumHypothesis.independent : Independent.{u} ContinuumHypothesis := by
  apply independent_of_mem_independenceSet
  simp [IndependenceSet]

/- Note the following is *not* true (i.e. `P = CH`):

theorem not_independent_of_true {P : Prop} (h : P) : ¬ Independent.{u} P := by
  sorry

However for every `Q : Prop` that we can actually unconditionally
prove under the standard axioms in Lean (or be able to prove its negation)
(think `True`, `2 = 0`, Fermat's last Theorem, ...),
`Independent Q` will not be provable.

Similarly, for any `Q : Prop`, `¬ Independent Q` will likely never be unconditionally be provable.

-/

end PiBase.Formal

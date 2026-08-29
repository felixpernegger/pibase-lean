module

public import PiBaseLean.AdditionalDefs.SetTheoryAxioms
public import PiBaseLean.Bundled.Basic

/-!
# Conditional results under set-theoretic hypotheses

When the project proves an implication between topological properties from one additional
set-theoretic hypothesis and its negation from another, this file provides a small structure for
packaging those conditional results while keeping both hypotheses visible in the type.

This is deliberately weaker than a formal statement of independence from ZFC. Such a statement
would require a formal theory together with a notion of provability or models. In particular, the
definitions below do not assert that any named context is consistent with ZFC.
-/

@[expose] public section

universe u

namespace PiBase.Formal

/-- Named set-theoretic contexts used to state conditional π-base results. -/
inductive SetTheoryContext
  /-- The continuum hypothesis. -/
  | continuumHypothesis
  /-- The negation of the continuum hypothesis. -/
  | notContinuumHypothesis
  /-- The generalized continuum hypothesis. -/
  | generalizedContinuumHypothesis
  /-- The negation of the generalized continuum hypothesis. -/
  | notGeneralizedContinuumHypothesis
  /-- Martin's axiom. -/
  | martinsAxiom
  /-- The negation of Martin's axiom. -/
  | notMartinsAxiom
  /-- Martin's axiom together with the negation of the continuum hypothesis. -/
  | martinsAxiomAndNotContinuumHypothesis
  deriving DecidableEq

/-- The proposition assumed by a named set-theoretic context.
The GCH contexts are interpreted in universe `u`. -/
def SetTheoryContext.toProp : SetTheoryContext → Prop
  | .continuumHypothesis => ContinuumHypothesis
  | .notContinuumHypothesis => NotContinuumHypothesis
  | .generalizedContinuumHypothesis => GeneralizedContinuumHypothesis.{u}
  | .notGeneralizedContinuumHypothesis => ¬ GeneralizedContinuumHypothesis.{u}
  | .martinsAxiom => MartinsAxiom
  | .notMartinsAxiom => ¬ MartinsAxiom
  | .martinsAxiomAndNotContinuumHypothesis => MartinsAxiom ∧ NotContinuumHypothesis

/--
`VariesUnder P A B` records that `P` follows in the explicit context `A`, while `¬ P` follows in
the distinct explicit context `B`.

This is conditional evidence only: it does not assert that either context is consistent with ZFC,
nor does it by itself prove that `P` is independent of any formal theory. Each declaration using
`VariesUnder` should expose both contexts in its type. Existentially quantifying the contexts would
recreate a vacuous independence predicate and must not be used for classification.
-/
structure VariesUnder (P : Prop) (positiveContext negativeContext : SetTheoryContext) : Prop where
  contexts_ne : positiveContext ≠ negativeContext
  of_positive : positiveContext.toProp.{u} → P
  not_of_negative : negativeContext.toProp.{u} → ¬ P

/-
Regression guardrail: existentially hiding the contexts is vacuous, just like the original
`Independent` definition. Requiring the context names to differ does not repair the existential
form, because complementary contexts can be oriented after case-splitting on `P`. Keep the contexts
visible in every public certificate.
-/
example (P : Prop) : ∃ A B, A ≠ B ∧ VariesUnder.{u} P A B := by
  classical
  by_cases hP : P
  · by_cases hCH : ContinuumHypothesis
    · refine ⟨.continuumHypothesis, .notContinuumHypothesis, by decide, ?_⟩
      exact ⟨by decide, fun _ ↦ hP, fun hNCH ↦
        (NotContinuumHypothesis.iff_not_continuumHypothesis.mp hNCH hCH).elim⟩
    · refine ⟨.notContinuumHypothesis, .continuumHypothesis, by decide, ?_⟩
      exact ⟨by decide, fun _ ↦ hP, fun hCH' ↦ (hCH hCH').elim⟩
  · by_cases hCH : ContinuumHypothesis
    · refine ⟨.notContinuumHypothesis, .continuumHypothesis, by decide, ?_⟩
      exact ⟨by decide, fun hNCH ↦
        (NotContinuumHypothesis.iff_not_continuumHypothesis.mp hNCH hCH).elim,
        fun _ ↦ hP⟩
    · refine ⟨.continuumHypothesis, .notContinuumHypothesis, by decide, ?_⟩
      exact ⟨by decide, fun hCH' ↦ (hCH hCH').elim, fun _ ↦ hP⟩

/-- Contexts that yield opposite conclusions cannot hold simultaneously. -/
protected theorem VariesUnder.contexts_incompatible {P : Prop} {A B : SetTheoryContext}
    (h : VariesUnder.{u} P A B) : ¬ (A.toProp.{u} ∧ B.toProp.{u}) :=
  fun ⟨hA, hB⟩ ↦ h.not_of_negative hB (h.of_positive hA)

/-- Negating the conclusion swaps the positive and negative contexts. -/
protected theorem VariesUnder.neg {P : Prop} {A B : SetTheoryContext}
    (h : VariesUnder.{u} P A B) : VariesUnder.{u} (¬ P) B A :=
  ⟨h.contexts_ne.symm, h.not_of_negative, fun hA hnP ↦ hnP (h.of_positive hA)⟩

/-- An implication between bundled properties varies under two explicit set-theoretic contexts.
The contexts are interpreted in the same universe as the properties. -/
abbrev ImplicationVariesUnder (p q : Property.{u})
    (positiveContext negativeContext : SetTheoryContext) : Prop :=
  VariesUnder.{u} (p ≤ q) positiveContext negativeContext

end PiBase.Formal

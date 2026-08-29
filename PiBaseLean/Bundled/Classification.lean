module

public import PiBaseLean.Bundled.SetTheoryVariation

/-!
# Auditable implication classifications

This file describes the evidence required to classify a fixed, finite catalogue of bundled
properties. Property identities are list indices rather than values of `Property`: two catalogue
entries must remain distinct even when their predicates are extensionally equal.

The status of every pair is an explicit parameter of `ClassificationFor`. In particular, the
contexts of a conditionally varying implication cannot be selected existentially inside a
classification proof.
-/

@[expose] public section

universe u

namespace PiBase.Formal

/-- An ordered pair of distinct entries in a property catalogue. -/
structure ImplicationPair (properties : List Property.{u}) where
  source : Fin properties.length
  target : Fin properties.length
  distinct : source ≠ target
  deriving DecidableEq, Fintype

namespace ImplicationPair

/-- The antecedent represented by an indexed implication pair. -/
def antecedent {properties : List Property.{u}}
    (pair : ImplicationPair properties) : Property.{u} :=
  properties[pair.source]

/-- The consequent represented by an indexed implication pair. -/
def consequent {properties : List Property.{u}}
    (pair : ImplicationPair properties) : Property.{u} :=
  properties[pair.target]

/-- The proposition represented by an indexed implication pair. -/
abbrev statement {properties : List Property.{u}} (pair : ImplicationPair properties) : Prop :=
  pair.antecedent ≤ pair.consequent

/-- Indexed implication pairs are equivalent to unequal pairs of catalogue positions. -/
def equivSubtype {properties : List Property.{u}} :
    ImplicationPair properties ≃
      {pair : Fin properties.length × Fin properties.length // pair.1 ≠ pair.2} where
  toFun pair := ⟨(pair.source, pair.target), pair.distinct⟩
  invFun pair := ⟨pair.1.1, pair.1.2, pair.2⟩
  left_inv pair := by cases pair; rfl
  right_inv pair := by cases pair; rfl

/-- The number of ordered pairs of distinct entries in a finite property catalogue. -/
theorem card (properties : List Property.{u}) :
    Fintype.card (ImplicationPair properties) =
      properties.length * properties.length - properties.length := by
  classical
  rw [Fintype.card_congr equivSubtype]
  rw [Fintype.card_subtype]
  change (Finset.univ.filter fun pair : Fin properties.length × Fin properties.length ↦
    pair.1 ≠ pair.2).card = _
  rw [show (Finset.univ.filter fun pair : Fin properties.length × Fin properties.length ↦
      pair.1 ≠ pair.2) = (Finset.univ : Finset (Fin properties.length)).offDiag by
    ext pair
    simp [Finset.mem_offDiag]]
  rw [Finset.offDiag_card]
  simp

end ImplicationPair

/-- The existence of a topological space satisfying `p` and refuting `q`. -/
def HasCounterexample (p q : Property.{u}) : Prop :=
  ∃ (X : Type u) (topology : TopologicalSpace X),
    @p.toPred X topology ∧ ¬ @q.toPred X topology

/-- Having a counterexample is equivalent to refuting the universal implication. -/
theorem hasCounterexample_iff_not_implication (p q : Property.{u}) :
    HasCounterexample p q ↔ ¬ p ≤ q :=
  (Property.not_le_iff p q).symm

/-- The three evidence-bearing statuses admitted by the project classification target. -/
inductive ImplicationStatus
  /-- The implication has an unconditional Lean proof. -/
  | proved
  /-- An existential topological counterexample refutes the implication. -/
  | refuted
  /-- The implication and its negation follow under two fixed, named contexts. -/
  | variesUnder (positiveContext negativeContext : SetTheoryContext)
  deriving DecidableEq

/-- Evidence required by a status for an implication `p ≤ q`. -/
def ImplicationStatus.Evidence (status : ImplicationStatus) (p q : Property.{u}) : Prop :=
  match status with
  | .proved => p ≤ q
  | .refuted => HasCounterexample p q
  | .variesUnder positiveContext negativeContext =>
      ImplicationVariesUnder p q positiveContext negativeContext

/-- A partial, explicit assignment of statuses to implication pairs. -/
abbrev ClassificationPlan (properties : List Property.{u}) :=
  ImplicationPair properties → Option ImplicationStatus

/-- Every status recorded by a plan has the evidence required by that status. -/
def ClassificationPlan.Sound {properties : List Property.{u}}
    (plan : ClassificationPlan properties) : Prop :=
  ∀ pair status, plan pair = some status →
    status.Evidence pair.antecedent pair.consequent

/-- A plan assigns a status to every implication pair in its catalogue. -/
def ClassificationPlan.Complete {properties : List Property.{u}}
    (plan : ClassificationPlan properties) : Prop :=
  ∀ pair, (plan pair).isSome

/--
Soundness and completeness of an explicit status plan for a property catalogue.

The `plan` function is deliberately visible in the type. A project-wide certificate should use a
concrete, reviewable plan; existentially hiding it would permit the same vacuous context selection
rejected by `SetTheoryVariation`.
-/
structure ClassificationFor (properties : List Property.{u})
    (plan : ClassificationPlan properties) : Prop where
  sound : plan.Sound
  complete : plan.Complete

end PiBase.Formal

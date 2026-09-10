module

public import PiBaseLean.Bundled.Independent

/-! This file develops the machinery to stating the ultimate goal of this project. -/

universe u

@[expose] public section

namespace PiBase.Formal

def implicationSet : List Property.{u} → Set (Property.{u} × Property.{u})
  | [] => ∅
  | a :: l => (implicationSet l) ∪ {(a, i) | i ∈ l} ∪ {(a, iᶜ) | i ∈ l}

def propertyPairToLe (e : Property.{u} × Property.{u}) : Prop :=
  e.1 ≤ e.2

structure ClassificationFor (s : Set (Property.{u} × Property.{u})) where
  trueSet : Set (Property.{u} × Property.{u})
  falseSet : Set (Property.{u} × Property.{u})
  indSet : Set (Property.{u} × Property.{u})
  union_eq : trueSet ∪ falseSet ∪ indSet = s
  trueSet_true : ∀ a ∈ trueSet, a.1 ≤ a.2
  falseSet_false : ∀ a ∈ falseSet, ¬ a.1 ≤ a.2
  indSet_ind : ∀ a ∈ indSet, IndependentImplication a.1 a.2

end PiBase.Formal

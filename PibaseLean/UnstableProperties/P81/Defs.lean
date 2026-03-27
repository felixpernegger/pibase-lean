import Mathlib

open Topology Set Function Filter TopologicalSpace

namespace UnstablePiBase

/- 81. Countably tight -/
class CountablyTightSpace (X : Type*) [TopologicalSpace X] : Prop where
  countably_tight : ∀ (x : X) (A : Set X), x ∈ closure A → ∃ D : Set X,
    D.Countable ∧ D ⊆ A ∧ x ∈ closure D

end UnstablePiBase

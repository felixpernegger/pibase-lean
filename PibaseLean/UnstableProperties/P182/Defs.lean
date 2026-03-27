import Mathlib

open Topology Set Function Filter TopologicalSpace

namespace UnstablePiBase

/- 182. Has a countable network -/
class HasCountableNetwork (X : Type*) [TopologicalSpace X] : Prop where
  has_countable_network : ∃ (N : ℕ → Set X),
    ∀ (x : X) (U : Set X) (_ : U ∈ 𝓝 x), ∃ i : ℕ, x ∈ N i ∧ N i ⊆ U

end UnstablePiBase

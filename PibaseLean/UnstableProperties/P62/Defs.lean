import Mathlib

open Topology Set Function Filter TopologicalSpace

namespace UnstablePiBase

/- 62. Weakly Lindelöf -/
class WeaklyLindelofSpace (X : Type*) [TopologicalSpace X] : Prop where
  weakly_lindelof : ∀ {ι : Type*} (U : ι → Set X),
    (∀ i, IsOpen (U i)) → (⋃ i, U i = univ) → ∃ t : Set ι, t.Countable ∧ Dense (⋃ i ∈ t, U i)

end UnstablePiBase

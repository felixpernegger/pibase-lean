import Mathlib

open Topology Set Function Filter TopologicalSpace

universe u

namespace UnstablePiBase

/- 68. Rothberger -/
class RothbergerSpace (X : Type u) [TopologicalSpace X] : Prop where
  rothberger : ∀ {ι : Type u} (U : ℕ → ι → Set X),
    (∀ (n : ℕ) (i : ι), IsOpen (U n i)) → (∀ (n : ℕ), univ = ⋃ (i : ι), (U n i)) →
      ∃ j : ℕ → ι, univ = ⋃ (n : ℕ), U n (j n)

end UnstablePiBase

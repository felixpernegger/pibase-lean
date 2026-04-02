import Mathlib.Topology.Defs.Basic

open Topology Set Function TopologicalSpace

universe u

namespace PiBase

/- 68. Rothberger -/
class RothbergerSpace (X : Type u) [TopologicalSpace X] : Prop where
  rothberger : ∀ {ι : Type} (U : ℕ → ι → Set X),
    (∀ (n : ℕ) (i : ι), IsOpen (U n i)) → (∀ (n : ℕ), univ = ⋃ (i : ι), (U n i)) →
      ∃ j : ℕ → ι, univ = ⋃ (n : ℕ), U n (j n)

end PiBase

module

public import Mathlib.Topology.Defs.Basic

@[expose] public section

open Set

universe u

namespace PiBase

/- 68. Rothberger -/
class RothbergerSpace (X : Type u) [TopologicalSpace X] : Prop where
  rothberger : ∀ {ι : Type u} (U : ℕ → ι → Set X), Nonempty ι →
    (∀ (n : ℕ) (i : ι), IsOpen (U n i)) → (∀ (n : ℕ), univ = ⋃ (i : ι), (U n i)) →
      ∃ j : ℕ → ι, univ = ⋃ (n : ℕ), U n (j n)

end PiBase

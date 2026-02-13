import Mathlib

open Topology Set Function

universe u

namespace PiBase

/-- 19. Countably compact -/
class CountablyCompactSpace (X : Type u) [TopologicalSpace X] : Prop where
  countablyCompact : ∀ {ι : Type u} (U : ι → Set X),
    (∀ i, IsOpen (U i)) → (univ = ⋃ i, U i) → ∃ t : Set ι, Countable t ∧ Set.univ ⊆ ⋃ i ∈ t, U i

end PiBase

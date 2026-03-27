import Mathlib

open Topology Set Function Filter TopologicalSpace

universe u

namespace UnstablePiBase

/- 66. Menger -/
class MengerSpace (X : Type u) [TopologicalSpace X] : Prop where
  menger : ∀ {ι : Type u} (U : ℕ → ι → Set X),
    (∀ (n : ℕ) (i : ι), IsOpen (U n i)) → (∀ (n : ℕ), univ = ⋃ (i : ι), (U n i)) →
      ∃ s : ℕ → (Finset ι), univ = ⋃ (n : ℕ), ⋃ i ∈ s n, U n i

end UnstablePiBase

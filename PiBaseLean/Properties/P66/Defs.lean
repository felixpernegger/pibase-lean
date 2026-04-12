module

public import Mathlib.Data.Finset.Defs
public import Mathlib.Topology.Defs.Basic
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function TopologicalSpace

universe u

namespace PiBase

/- 66. Menger -/
class MengerSpace (X : Type u) [TopologicalSpace X] : Prop where
  menger : ∀ {ι : Type u} (U : ℕ → ι → Set X),
    (∀ (n : ℕ) (i : ι), IsOpen (U n i)) → (∀ n : ℕ, univ = ⋃ i : ι, U n i) →
      ∃ s : ℕ → Finset ι, univ = ⋃ n : ℕ, ⋃ i ∈ s n, U n i

end PiBase

namespace PiBase.Formal

def P66 : Property where
  toPred := MengerSpace
  well_defined φ h := sorry

end PiBase.Formal

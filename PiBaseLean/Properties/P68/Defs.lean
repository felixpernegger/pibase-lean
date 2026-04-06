import Mathlib.Topology.Defs.Basic
import PiBaseLean.Properties.Bundled.Defs

open Topology Set Function TopologicalSpace

universe u

namespace PiBase

/- 68. Rothberger -/
class RothbergerSpace (X : Type u) [TopologicalSpace X] : Prop where
  rothberger : ∀ {ι : Type u} (U : ℕ → ι → Set X),
    (∀ (n : ℕ) (i : ι), IsOpen (U n i)) → (∀ (n : ℕ), univ = ⋃ (i : ι), (U n i)) →
      ∃ j : ℕ → ι, univ = ⋃ (n : ℕ), U n (j n)

end PiBase

namespace PiBase.Formal

def P68 : Property where
  toPred := RothbergerSpace
  well_defined' φ h := sorry

end PiBase.Formal

import Mathlib.Data.Set.Countable
import Mathlib.Topology.Defs.Basic
import PiBaseLean.Properties.Bundled.Defs

open Topology Set Function TopologicalSpace

namespace PiBase

/- 62. Weakly Lindelöf -/
class WeaklyLindelofSpace (X : Type*) [TopologicalSpace X] : Prop where
  weakly_lindelof : ∀ {ι : Type*} (U : ι → Set X),
    (∀ i, IsOpen (U i)) → (⋃ i, U i = univ) → ∃ t : Set ι, t.Countable ∧ Dense (⋃ i ∈ t, U i)

end PiBase

namespace PiBase.Formal

def P62 : Property where
  toPred := WeaklyLindelofSpace
  well_defined' φ h := sorry

end PiBase.Formal

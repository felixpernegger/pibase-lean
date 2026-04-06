import Mathlib.Topology.Defs.Filter
import PiBaseLean.Properties.Bundled.Defs

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 182. Has a countable network -/
class HasCountableNetwork (X : Type*) [TopologicalSpace X] : Prop where
  has_countable_network : ∃ (N : ℕ → Set X),
    ∀ (x : X) (U : Set X) (_ : U ∈ 𝓝 x), ∃ i : ℕ, x ∈ N i ∧ N i ⊆ U

end PiBase

namespace PiBase.Formal

def P182 : Property where
  toPred := HasCountableNetwork
  well_defined' φ h := sorry

end PiBase.Formal

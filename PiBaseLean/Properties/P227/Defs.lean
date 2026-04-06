import Mathlib.SetTheory.Cardinal.Continuum
import Mathlib.Topology.Constructions
import PiBaseLean.Properties.Bundled.Defs

open TopologicalSpace Cardinal

namespace PiBase

/- 227. Has a closed discrete subset of cardinality 𝔠 -/
class HasClosedDiscreteSubsetCardContinuum (X : Type*) [TopologicalSpace X] : Prop where
  ex_subset : ∃ s : Set X, IsDiscrete s ∧ IsClosed s ∧ #s = 𝔠

end PiBase

namespace PiBase.Formal

def P227 : Property where
  toPred := HasClosedDiscreteSubsetCardContinuum
  well_defined' φ h := sorry

end PiBase.Formal

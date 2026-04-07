import Mathlib.Topology.Separation.Regular
import PiBaseLean.Properties.P182.Defs

namespace PiBase

/- 74. Cosmic -/
class CosmicSpace (X : Type*) [TopologicalSpace X] : Prop extends
  T3Space X, HasCountableNetwork X

end PiBase

namespace PiBase.Formal

def P74 : Property where
  toPred := CosmicSpace
  well_defined φ h := sorry

end PiBase.Formal

module

public import Mathlib.Topology.Separation.Regular
public import PiBaseLean.Properties.P182.Defs

@[expose] public section

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

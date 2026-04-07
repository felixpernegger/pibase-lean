import Mathlib.Topology.Connected.Basic
import PiBaseLean.Properties.Bundled.Defs

namespace PiBase

/- 234. Has open connected components -/
class HasOpenConnectedComponents (X : Type*) [TopologicalSpace X] : Prop where
  component_open (x : X) : IsOpen (connectedComponent x)

end PiBase

namespace PiBase.Formal

def P234 : Property where
  toPred := HasOpenConnectedComponents
  well_defined φ h := sorry

end PiBase.Formal

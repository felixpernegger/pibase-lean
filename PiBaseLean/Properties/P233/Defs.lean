import Mathlib.Topology.Connected.PathConnected
import PiBaseLean.Properties.Bundled.Defs

namespace PiBase

/- 233. Has open path components -/
class HasOpenPathComponents (X : Type*) [TopologicalSpace X] : Prop where
  component_open (x : X) : IsOpen (pathComponent x)

end PiBase

namespace PiBase.Formal

def P233 : Property where
  toPred := HasOpenPathComponents
  well_defined' φ h := sorry

end PiBase.Formal

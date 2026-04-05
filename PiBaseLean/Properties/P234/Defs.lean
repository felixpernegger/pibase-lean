import Mathlib.Topology.Connected.Basic

namespace PiBase

/- 234. Has open connected components -/
class HasOpenConnectedComponents (X : Type*) [TopologicalSpace X] : Prop where
  component_open (x : X) : IsOpen (connectedComponent x)

end PiBase

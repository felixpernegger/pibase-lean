import Mathlib.Topology.Connected.Basic

universe u

namespace PiBase

/- 234. Has open connected components -/
class HasOpenConnectedComponents (X : Type u) [TopologicalSpace X] : Prop where
  component_open (x : X) : IsOpen (connectedComponent x)

end PiBase

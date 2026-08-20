module

public import Mathlib.Topology.Connected.Basic

@[expose] public section

namespace PiBase

/- 234. Has open connected components -/
class HasOpenConnectedComponents (X : Type*) [TopologicalSpace X] : Prop where
  component_open (x : X) : IsOpen (connectedComponent x)

end PiBase

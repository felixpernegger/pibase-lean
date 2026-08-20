module

public import Mathlib.Topology.Connected.PathConnected

@[expose] public section

namespace PiBase

/- 233. Has open path components -/
class HasOpenPathComponents (X : Type*) [TopologicalSpace X] : Prop where
  component_open (x : X) : IsOpen (pathComponent x)

end PiBase

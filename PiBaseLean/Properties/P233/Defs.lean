import Mathlib.Topology.Connected.PathConnected

universe u

namespace PiBase

/- 233. Has open path components -/
class CountablyMetacompactSpace (X : Type u) [TopologicalSpace X] : Prop where
  component_open (x : X) : IsOpen (pathComponent x)

end PiBase

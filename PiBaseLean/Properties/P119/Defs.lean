module

public import Mathlib.Topology.ExtremallyDisconnected

@[expose] public section

namespace PiBase

/- 119. Stonean space -/ -- NOTE: The category of these spaces exists in mathlib
class StoneanSpace (X : Type*) [TopologicalSpace X] : Prop
  extends CompactSpace X, ExtremallyDisconnected X, T2Space X

end PiBase

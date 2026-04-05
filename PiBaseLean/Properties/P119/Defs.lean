import Mathlib.Topology.ExtremallyDisconnected

open TopologicalSpace

universe u

namespace PiBase

/- 119. Stonean space -/ -- NOTE: The category of these spaces exists in mathlib
class StoneanSpace (X : Type u) [TopologicalSpace X] : Prop
  extends CompactSpace X, ExtremallyDisconnected X, T2Space X

end PiBase

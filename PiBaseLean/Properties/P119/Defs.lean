import Mathlib.Topology.ExtremallyDisconnected
import PiBaseLean.Properties.Bundled.Defs

open TopologicalSpace

namespace PiBase

/- 119. Stonean space -/ -- NOTE: The category of these spaces exists in mathlib
class StoneanSpace (X : Type*) [TopologicalSpace X] : Prop
  extends CompactSpace X, ExtremallyDisconnected X, T2Space X

end PiBase

namespace PiBase.Formal

def P119 : Property where
  toPred X := StoneanSpace X
  well_defined φ _ := @StoneanSpace.mk _ _ φ.compactSpace
    (extremallyDisconnected_of_homeo φ) φ.t2Space

end PiBase.Formal

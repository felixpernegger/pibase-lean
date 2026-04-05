import Mathlib.Topology.GDelta.Basic
import PiBaseLean.Properties.Bundled.Defs

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 56. Meager -/
class MeagreSpace (X : Type*) [TopologicalSpace X] : Prop where
  meagre : IsMeagre (univ (α := X))

end PiBase

namespace PiBase.Formal

def P56 : Property where
  toPred := MeagreSpace
  well_defined' φ h := by
    constructor
    convert φ.isInducing.isMeagre_image h.meagre
    simp only [image_univ, EquivLike.range_eq_univ]

end PiBase.Formal

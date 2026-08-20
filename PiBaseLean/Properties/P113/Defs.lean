module

public import Mathlib.Topology.Separation.Regular
public import PiBaseLean.Properties.P110.Defs

@[expose] public section

open Topology Set

namespace PiBase

/- 113. Moore Space -/
class MooreSpace (X : Type*) [TopologicalSpace X] extends DevelopableSpace X, T3Space X

end PiBase

namespace PiBase.Formal

def P113 : Property where
  toPred := MooreSpace
  well_defined φ h := by
    have hDev := h.toDevelopableSpace
    have hDevY := Formal.P110.well_defined φ hDev
    have hT3 := h.toT3Space
    have := hT3
    have hT3Y := φ.t3Space
    exact { toDevelopableSpace := hDevY, toT3Space := hT3Y }

end PiBase.Formal

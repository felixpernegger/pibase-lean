module

public import PiBaseLean.Properties.P32.Defs
public import Mathlib.Topology.Separation.Regular

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 127. Dowker -/
class DowkerSpace (X : Type u) [TopologicalSpace X] : Prop extends T4Space X where
  ncountably_paracompact : ¬ CountablyParacompactSpace X

end PiBase

namespace PiBase.Formal

def P127 : Property where
  toPred := DowkerSpace
  well_defined φ h := sorry

end PiBase.Formal

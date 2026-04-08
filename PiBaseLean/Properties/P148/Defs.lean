module

public import PiBaseLean.Properties.P141.Defs
public import PiBaseLean.Properties.P143.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 148. CWGH -/
class CWGH (X : Type u) [TopologicalSpace X] : Prop extends K2Space X, WeakT2Space X

end PiBase

namespace PiBase.Formal

def P148 : Property where
  toPred := CWGH
  well_defined φ h := sorry

end PiBase.Formal

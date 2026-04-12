module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P162.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 215. Hereditarily realcompact -/
class HereditarilyRealcompactSpace (X : Type u) [TopologicalSpace X] : Prop where
  subset_realcompact : Hereditarily RealcompactSpace X

end PiBase

namespace PiBase.Formal

def P215 : Property where
  toPred := HereditarilyRealcompactSpace
  well_defined φ h := sorry

end PiBase.Formal

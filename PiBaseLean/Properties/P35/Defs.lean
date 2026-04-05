import PiBaseLean.Properties.P34.Defs

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 35. Fully T₄ -/
class FullyT4Space (X : Type*) [TopologicalSpace X] : Prop extends T1Space X, FullyNormalSpace X

end PiBase

namespace PiBase.Formal

def P35 : Property where
  toPred := FullyT4Space
  well_defined' φ h := @FullyT4Space.mk _ _ φ.t1Space (P34.well_defined' φ h.toFullyNormalSpace)

end PiBase.Formal

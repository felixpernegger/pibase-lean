import PiBaseLean.Properties.P110.Defs

open Topology Set

namespace PiBase

/- 113. Moore Space -/
class MooreSpace (X : Type*) [TopologicalSpace X] extends DevelopableSpace X, T3Space X

end PiBase

namespace PiBase.Formal

def P113 : Property where
  toPred := MooreSpace
  well_defined φ h := sorry

end PiBase.Formal

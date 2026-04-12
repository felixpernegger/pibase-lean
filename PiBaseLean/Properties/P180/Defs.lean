module

public import Mathlib.Topology.Bases
public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open TopologicalSpace

namespace PiBase

/- 180. Hereditarily separable -/
class HereditarilySeparableSpace (X : Type*) [TopologicalSpace X] : Prop where
  subset_separable : Hereditarily SeparableSpace X

end PiBase

namespace PiBase.Formal

def P180 : Property where
  toPred := HereditarilySeparableSpace
  well_defined φ h := sorry

end PiBase.Formal

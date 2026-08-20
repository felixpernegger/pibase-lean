module

public import Mathlib.Topology.Bases
public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P26.Bundled

@[expose] public section

open TopologicalSpace

namespace PiBase

/- 180. Hereditarily separable -/
class HereditarilySeparableSpace (X : Type*) [TopologicalSpace X] : Prop where
  subset_separable : Hereditarily SeparableSpace X

end PiBase

module

public import PiBaseLean.AdditionalDefs
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Filter TopologicalSpace Topology.PiBase.AdditionalDefs Cardinal

universe u

namespace PiBase

/- 198. Has countable extent -/
class HasCountableExtent (X : Type u) [TopologicalSpace X] : Prop where
  spread_eq : Extent X = ℵ₀

end PiBase

namespace PiBase.Formal

def P198 : Property where
  toPred := HasCountableExtent
  well_defined φ h := sorry

end PiBase.Formal

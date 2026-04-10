module

public import PiBaseLean.AdditionalDefs
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Filter TopologicalSpace PiBase.AdditionalDefs Cardinal

universe u

namespace PiBase

/- 197. Has countable spread -/
class HasCountableSpread (X : Type u) [TopologicalSpace X] : Prop where
  spread_eq : Spread X = ℵ₀

end PiBase

namespace PiBase.Formal

def P197 : Property where
  toPred := HasCountableSpread
  well_defined φ h := sorry

end PiBase.Formal

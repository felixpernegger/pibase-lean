module

public import PiBaseLean.AdditionalDefs.Cardinal

@[expose] public section

open Cardinal

universe u

namespace PiBase

/- 197. Has countable spread -/
class HasCountableSpread (X : Type u) [TopologicalSpace X] : Prop where
  spread_eq : Spread X = ℵ₀

end PiBase

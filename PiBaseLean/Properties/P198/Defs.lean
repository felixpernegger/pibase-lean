module

public import PiBaseLean.AdditionalDefs.Cardinal

@[expose] public section

open Cardinal

universe u

namespace PiBase

/- 198. Has countable extent -/
class HasCountableExtent (X : Type u) [TopologicalSpace X] : Prop where
  extent_eq : Extent X = ℵ₀

end PiBase

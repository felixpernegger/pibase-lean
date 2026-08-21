module

public import PiBaseLean.AdditionalDefs.Cardinal

@[expose] public section

universe u

namespace PiBase

open Cardinal

/- 164. Cardinality less than every measurable cardinal -/
class CardLtEveryMeasurableCardinal (X : Type u) : Prop where
  card_lt_every_measurable (k : Cardinal.{u}) : IsMeasurable k → #X < k

end PiBase

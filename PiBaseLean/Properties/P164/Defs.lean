module

public import PiBaseLean.AdditionalDefs.Cardinal
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

universe u

namespace PiBase

open Cardinal Set Filter Topology

/- 164. Cardinality less than every measurable cardinal -/
class CardLtEveryMeasurableCardinal (X : Type u) : Prop where
  card_lt_every_measurable (k : Cardinal.{u}) : IsMeasurable k → #X < k

end PiBase

namespace PiBase.Formal

def P164 : Property where
  toPred X := CardLtEveryMeasurableCardinal X
  well_defined φ h := sorry

end PiBase.Formal

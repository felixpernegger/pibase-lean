module

public import Mathlib.SetTheory.Cardinal.Order

@[expose] public section

open Cardinal

namespace PiBase

/-- 175. Cardinality ≥ 3 -/
class CardGeThree (X : Type*) : Prop where
  card_ge : 3 ≤ #X

end PiBase

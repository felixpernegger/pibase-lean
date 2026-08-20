module

public import Mathlib.SetTheory.Cardinal.Order
public import Mathlib.Topology.Defs.Basic

@[expose] public section

open Cardinal

namespace PiBase

/-- 175. Cardinality ≥ 3 -/
class CardGeThree (X : Type*) : Prop where
  card_ge : 3 ≤ #X

end PiBase

module

public import Mathlib.SetTheory.Cardinal.Order
public import Mathlib.Topology.Defs.Basic

@[expose] public section

open Cardinal

namespace PiBase

/-- 176. Cardinality ≥ 4 -/
class CardGeFour (X : Type*) : Prop where
  card_ge : 4 ≤ #X

end PiBase

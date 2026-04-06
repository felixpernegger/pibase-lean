import Mathlib.SetTheory.Cardinal.Order
import Mathlib.Topology.Defs.Basic

open Cardinal

universe u

namespace PiBase

/-- 176. Cardinality ≥ 3 -/
class CardGeThree (X : Type u) : Prop where
  card_ge : 3 ≤ #X

end PiBase

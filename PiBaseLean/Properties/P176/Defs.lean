import Mathlib.SetTheory.Cardinal.Order
import Mathlib.Topology.Defs.Basic

open Cardinal

universe u

namespace PiBase

/-- 176. Cardinality ≥ 4 -/
class CardGeFour (X : Type u) : Prop where
  card_ge : 4 ≤ #X

end PiBase

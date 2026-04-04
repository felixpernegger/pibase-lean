import Mathlib.Data.Countable.Defs
import Mathlib.Order.BourbakiWitt
import Mathlib.Topology.Defs.Basic

open Topology Set Function TopologicalSpace

namespace PiBase

/- 29. Countable chain condition -/
class CountableChainCondition (X : Type*) [TopologicalSpace X] : Prop where
  countable_chain_condition : ∀ (S : Set (Set X)),
    S.PairwiseDisjoint id → (∀ s ∈ S, IsOpen s) → Countable S

end PiBase

module

public import Mathlib.Data.Set.Countable
public import Mathlib.Order.BourbakiWitt
public import Mathlib.Topology.Defs.Basic

@[expose] public section

open Topology Set Function TopologicalSpace

namespace PiBase

/- 29. Countable chain condition -/
class CountableChainCondition (X : Type*) [TopologicalSpace X] : Prop where
  countable_chain_condition : ∀ ⦃S : Set (Set X)⦄,
    S.PairwiseDisjoint id → (∀ s ∈ S, IsOpen s) → S.Countable

end PiBase

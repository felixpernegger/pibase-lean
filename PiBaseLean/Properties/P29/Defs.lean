module

public import Mathlib.Data.Countable.Defs
public import Mathlib.Order.BourbakiWitt
public import Mathlib.Topology.Defs.Basic
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function TopologicalSpace

namespace PiBase

/- 29. Countable chain condition -/
class CountableChainCondition (X : Type*) [TopologicalSpace X] : Prop where
  countable_chain_condition : ∀ (S : Set (Set X)),
    S.PairwiseDisjoint id → (∀ s ∈ S, IsOpen s) → Countable S

end PiBase

namespace PiBase.Formal

def P29 : Property where
  toPred := CountableChainCondition
  well_defined φ h := sorry

end PiBase.Formal

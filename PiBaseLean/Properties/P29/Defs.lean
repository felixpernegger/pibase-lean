import Mathlib.Data.Countable.Defs
import Mathlib.Order.BourbakiWitt
import Mathlib.Topology.Defs.Basic
import PiBaseLean.Properties.Bundled.Defs

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
  well_defined' φ h := sorry

end PiBase.Formal

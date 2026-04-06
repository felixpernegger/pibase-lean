import Mathlib.Order.Filter.AtTopBot.Defs
import Mathlib.Topology.Defs.Filter
import PiBaseLean.Properties.Bundled.Defs

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 99. US -/
class UsSpace (X : Type*) [TopologicalSpace X] : Prop where
  us : ∀ (f : ℕ → X) (a b : X), Tendsto f atTop (𝓝 a) → Tendsto f atTop (𝓝 b) → a = b

end PiBase

namespace PiBase.Formal

def P99 : Property where
  toPred := UsSpace
  well_defined' φ h := sorry

end PiBase.Formal

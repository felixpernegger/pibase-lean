module

public import Mathlib.Topology.Order.Basic
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 167. Sequentially discrete -/
class SeqDiscreteSpace (X : Type u) [TopologicalSpace X] : Prop where
  tendsto_constant : ∀ᵉ (s : ℕ → X) (x : X), Tendsto s atTop (𝓝 x) → ∀ᶠ n in atTop, s n = x

end PiBase

namespace PiBase.Formal

def P167 : Property where
  toPred := SeqDiscreteSpace
  well_defined φ h := sorry

end PiBase.Formal

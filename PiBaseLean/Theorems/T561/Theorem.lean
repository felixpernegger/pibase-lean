module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P197.Defs
public import PiBaseLean.Properties.P198.Defs

@[expose] public section

universe u

open Topology Set Function Filter Cardinal

namespace PiBase

/-- Theorem T561: P197 (HasCountableSpread) => P198 (HasCountableExtent) -/
instance instHasCountableExtentOfHasCountableSpread (X : Type u)
    [TopologicalSpace X] [h : HasCountableSpread X] :
    HasCountableExtent X where
  extent_eq := le_antisymm (h.spread_eq ▸ extent_le_spread X) (aleph_zero_le_extent X)

end PiBase

namespace PiBase.Formal

theorem T561 : P197 ≤ P198 := fun X _ ↦ @instHasCountableExtentOfHasCountableSpread X _

end PiBase.Formal

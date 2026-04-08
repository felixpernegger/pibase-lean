module

public import PiBaseLean.Properties.P183.Defs
public import Mathlib.Topology.Separation.Regular

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 179. ℵ₀-space -/
class AlephZeroSpace (X : Type u) [TopologicalSpace X] : Prop extends
    T3Space X, HasCountableKNetwork X

end PiBase

namespace PiBase.Formal

def P179 : Property where
  toPred := AlephZeroSpace
  well_defined φ h := sorry

end PiBase.Formal

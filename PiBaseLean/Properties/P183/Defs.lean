module

public import PiBaseLean.AdditionalDefs
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace Topology.PiBase.AdditionalDefs

universe u

namespace PiBase

/- 183. Has a countable k-network -/
class HasCountableKNetwork (X : Type u) [TopologicalSpace X] : Prop where
  ex_network : ∃ (ι : Type) (f : ι → Set X), Countable ι ∧ IsKNetwork f

end PiBase

namespace PiBase.Formal

def P183 : Property where
  toPred := HasCountableKNetwork
  well_defined φ h := sorry

end PiBase.Formal

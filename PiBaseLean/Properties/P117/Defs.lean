module

public import PiBaseLean.AdditionalDefs
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace Topology.PiBase.AdditionalDefs

universe u

namespace PiBase

/- 117. Has a σ-locally finite network -/
class HasSigmaLocallyFiniteNetwork (X : Type u) [TopologicalSpace X] : Prop where
  ex_network : ∃ (ι : Type u) (f : ι → Set X), Sigma LocallyFinite f ∧ IsNetwork f

end PiBase

namespace PiBase.Formal

def P117 : Property where
  toPred := HasSigmaLocallyFiniteNetwork
  well_defined φ h := sorry

end PiBase.Formal

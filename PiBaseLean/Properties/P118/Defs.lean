module

public import PiBaseLean.AdditionalDefs
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace PiBase.AdditionalDefs

universe u

namespace PiBase

/- 118. Has a σ-locally finite k-network -/
class HasSigmaLocallyFiniteKNetwork (X : Type u) [TopologicalSpace X] : Prop where
  ex_network : ∃ (ι : Type u) (f : ι → Set X), Sigma LocallyFinite f ∧ IsKNetwork f

end PiBase

namespace PiBase.Formal

def P118 : Property where
  toPred := HasSigmaLocallyFiniteKNetwork
  well_defined φ h := sorry

end PiBase.Formal

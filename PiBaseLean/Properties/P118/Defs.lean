module

public import PiBaseLean.AdditionalDefs.Cover
public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

universe u

namespace PiBase

/- 118. Has a σ-locally finite k-network -/
class HasSigmaLocallyFiniteKNetwork (X : Type u) [TopologicalSpace X] : Prop where
  ex_network : ∃ (ι : Type u) (f : ι → Set X), Sigma LocallyFinite f ∧ IsKNetwork f

end PiBase

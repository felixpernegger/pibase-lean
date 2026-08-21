module

public import PiBaseLean.AdditionalDefs.Cover
public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

universe u

namespace PiBase

/- 117. Has a σ-locally finite network -/
class HasSigmaLocallyFiniteNetwork (X : Type u) [TopologicalSpace X] : Prop where
  ex_network : ∃ (ι : Type u) (f : ι → Set X), Sigma LocallyFinite f ∧ IsNetwork f

end PiBase

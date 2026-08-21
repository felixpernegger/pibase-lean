module

public import PiBaseLean.AdditionalDefs.Constructions

@[expose] public section

namespace PiBase

/- 61. Cozero complemented -/
class CozeroComplementedSpace (X : Type*) [TopologicalSpace X] : Prop where
  cozero_complemented : ∀ s : Set X, IsCozero s → ∃ t : Set X,
    IsCozero t ∧ Disjoint s t ∧ Dense (s ∪ t)

end PiBase

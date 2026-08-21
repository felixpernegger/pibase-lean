module

public import PiBaseLean.AdditionalDefs.Constructions

@[expose] public section

universe u

namespace PiBase

/- 169. Semi-hausdorff -/
class SemiT2Space (X : Type u) [TopologicalSpace X] : Prop where
  ex_regular_open : Pairwise fun x y ↦ ∃ s : Set X, IsRegularOpen s ∧ x ∈ s ∧ y ∉ s

end PiBase

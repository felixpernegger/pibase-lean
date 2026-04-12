module

public import PiBaseLean.AdditionalDefs.Constructions
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 169. Semi-hausdorff -/
class SemiT2Space (X : Type u) [TopologicalSpace X] : Prop where
  ex_regular_open : Pairwise fun x y ↦ ∃ s : Set X, IsRegularOpen s ∧ x ∈ s ∧ y ∉ s

end PiBase

namespace PiBase.Formal

def P169 : Property where
  toPred := SemiT2Space
  well_defined φ h := sorry

end PiBase.Formal

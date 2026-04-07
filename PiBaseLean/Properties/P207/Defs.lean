module

public import Mathlib.Data.Rel
public import Mathlib.Topology.Constructions.SumProd
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Set

open scoped SetRel

namespace PiBase

/- 207. Strongly collectionwise normal -/
class StronglyCollectionwiseNormalSpace (X : Type*) [TopologicalSpace X] : Prop where
  subset_diagonal {s : Set (X × X)} (ds : diagonal X ⊆ s) (hs : IsOpen s) :
    ∃ t : Set (X × X), diagonal X ⊆ t ∧ IsOpen t ∧ t ○ t ⊆ s

end PiBase

namespace PiBase.Formal

def P207 : Property where
  toPred := StronglyCollectionwiseNormalSpace
  well_defined φ h := sorry

end PiBase.Formal

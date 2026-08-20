module

public import Mathlib.Data.Rel
public import Mathlib.Topology.Constructions.SumProd

@[expose] public section

universe u

open Set

open scoped SetRel

namespace PiBase

/- 207. Strongly collectionwise normal -/
class StronglyCollectionwiseNormalSpace (X : Type*) [TopologicalSpace X] : Prop where
  subset_diagonal {s : Set (X × X)} (ds : diagonal X ⊆ s) (hs : IsOpen s) :
    ∃ t : Set (X × X), diagonal X ⊆ t ∧ IsOpen t ∧ t ○ t ⊆ s

end PiBase

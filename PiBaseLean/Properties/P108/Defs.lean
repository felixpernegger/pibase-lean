module

public import PiBaseLean.Properties.P88.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 108. Hereditarily collectionwise normal -/
class HereditarilyCollectionwiseNormalSpace (X : Type*) [TopologicalSpace X] : Prop where
  hereditarily_collectionwise_normal : ∀ s : Set X, CollectionwiseNormalSpace s

end PiBase

namespace PiBase.Formal

def P108 : Property where
  toPred := HereditarilyCollectionwiseNormalSpace
  well_defined φ h := sorry

end PiBase.Formal

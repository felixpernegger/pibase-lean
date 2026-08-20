module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P88.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 108. Hereditarily collectionwise normal -/
class HereditarilyCollectionwiseNormalSpace (X : Type*) [TopologicalSpace X] : Prop where
  hereditarily_collectionwise_normal : Hereditarily CollectionwiseNormalSpace X

end PiBase

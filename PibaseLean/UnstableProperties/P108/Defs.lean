import Mathlib
import PibaseLean.UnstableProperties.P88.Defs

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 108. Hereditarily collectionwise normal -/
class HereditarilyCollectionwiseNormalSpace (X : Type*) [TopologicalSpace X] : Prop where
  hereditarily_collectionwise_normal : ∀ s : Set X, CollectionwiseNormalSpace s

end PiBase

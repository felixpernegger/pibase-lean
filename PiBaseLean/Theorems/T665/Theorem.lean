module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P88.Defs
public import PiBaseLean.Properties.P88.Lemmas
public import PiBaseLean.Properties.P108.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T665: P108 (HereditarilyCollectionwiseNormalSpace) => P88 (CollectionwiseNormalSpace) -/
instance instCollectionwiseNormalSpaceOfHereditarilyCollectionwiseNormalSpace (X : Type u)
    [TopologicalSpace X] [h : HereditarilyCollectionwiseNormalSpace X] :
    CollectionwiseNormalSpace X :=
  h.hereditarily_collectionwise_normal.toProperty WellDefined.collectionwiseNormalSpace

end PiBase

namespace PiBase.Formal

theorem T665 : P108 ≤ P88 := fun X _ ↦ @instCollectionwiseNormalSpaceOfHereditarilyCollectionwiseNormalSpace X _

end PiBase.Formal

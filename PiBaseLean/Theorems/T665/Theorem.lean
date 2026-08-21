module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P108.Bundled
public import PiBaseLean.Properties.P88.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T665: P108 (HereditarilyCollectionwiseNormalSpace) => P88 (CollectionwiseNormalSpace) -/
instance instCollectionwiseNormalSpaceOfHereditarilyCollectionwiseNormalSpace {X : Type u}
    [TopologicalSpace X] [h : HereditarilyCollectionwiseNormalSpace X] :
    CollectionwiseNormalSpace X :=
  h.hereditarily_collectionwise_normal.toProperty WellDefined.collectionwiseNormalSpace

end PiBase

namespace PiBase.Formal

theorem T665 : P108 ≤ P88 :=
  fun X _ ↦ @instCollectionwiseNormalSpaceOfHereditarilyCollectionwiseNormalSpace X _

end PiBase.Formal

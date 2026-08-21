module

public import PiBaseLean.AdditionalDefs.Cover

@[expose] public section

open Set

universe u

namespace PiBase

/- 88. Collectionwise normal -/
class CollectionwiseNormalSpace (X : Type u) [TopologicalSpace X] : Prop where
  collectionwise_normal : ∀ {ι : Type u} (F : ι → Set X),
      IsDiscreteFamily F → (∀ i : ι, IsClosed (F i)) →
        ∃ U : ι → Set X, (univ.PairwiseDisjoint U) ∧
          (∀ i : ι, IsOpen (U i)) ∧ (∀ i : ι, F i ⊆ U i)

end PiBase

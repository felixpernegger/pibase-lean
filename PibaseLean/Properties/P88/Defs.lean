import Mathlib
import PibaseLean.AdditionalDefs

open Topology Set Function Filter TopologicalSpace Topology.PiBase.AdditionalDefs

universe u

namespace PiBase

/- 88. Collectionwise normal -/
class CollectionwiseNormalSpace (X : Type u) [TopologicalSpace X] : Prop where
  collectionwise_normal : ∀ {ι : Type u} (F : ι → Set X),
      IsDiscreteFamily F → (∀ i : ι, IsClosed (F i)) →
        ∃ U : ι → Set X, (univ.PairwiseDisjoint U)
          ∧ (∀ i : ι, IsOpen (U i)) ∧ (∀ i : ι, U i ⊆ F i)

end PiBase

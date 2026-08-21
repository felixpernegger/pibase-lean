module

public import PiBaseLean.AdditionalDefs.Cover

@[expose] public section

universe u

namespace PiBase

/- 246. Collectionwise Hausdorff -/
class CollectionwiseHausdorffSpace (X : Type u) [TopologicalSpace X] : Prop where
  collectionwise_hausdorff : ∀ u : Set X, IsClosed u → IsDiscrete u → ∃ s : Set (Set X),
    (∀ a ∈ s, IsOpen a) ∧ (∀ᵉ (a ∈ s) (b ∈ s), a ≠ b → Disjoint a b) ∧ (∀ x ∈ u, ∃ a ∈ s, x ∈ a) ∧
      ∀ a ∈ s, ∃! x ∈ u, x ∈ a

end PiBase

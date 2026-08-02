module

public import PiBaseLean.AdditionalDefs.Cover
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

universe u

namespace PiBase

/- 246. Collectionwise Hausdorff -/
class CollectionwiseHausdorffSpace (X : Type u) [TopologicalSpace X] : Prop where
  collectionwise_hausdorff : ∀ u : Set X, IsDiscrete u → ∃ s : Set (Set X),
    (∀ a ∈ s, IsOpen a) ∧ (∀ᵉ (a ∈ s) (b ∈ s), a ≠ b → Disjoint a b) ∧ ∀ x ∈ u, ∃ a ∈ s, x ∈ u

end PiBase

namespace PiBase.Formal

def P246 : Property where
  toPred := CollectionwiseHausdorffSpace
  well_defined φ h := sorry

end PiBase.Formal

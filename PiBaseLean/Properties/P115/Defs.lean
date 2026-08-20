module

public import PiBaseLean.AdditionalDefs.Cover
public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 115. Subparacompact -/
class SubparacompactSpace (X : Type u) [TopologicalSpace X] : Prop where
  locallyFinite_refinement :
    ∀ (α : Type u) (s : α → Set X), (∀ a, IsOpen (s a)) → (⋃ a, s a = univ) →
      ∃ (β : Type u) (t : β → Set X),
        (∀ b, IsClosed (t b)) ∧ (⋃ b, t b = univ) ∧ Sigma LocallyFinite t ∧ ∀ b, ∃ a, t b ⊆ s a

end PiBase

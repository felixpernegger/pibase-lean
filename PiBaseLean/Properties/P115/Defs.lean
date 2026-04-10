module

public import PiBaseLean.AdditionalDefs
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace PiBase.AdditionalDefs

universe u

namespace PiBase

/- 115. Subparacompact -/
class SubparacompactSpace (X : Type u) [TopologicalSpace X] : Prop where
  locallyFinite_refinement :
    ∀ (α : Type u) (s : α → Set X), (∀ a, IsOpen (s a)) → (⋃ a, s a = univ) →
      ∃ (β : Type u) (t : β → Set X),
        (∀ b, IsClosed (t b)) ∧ (⋃ b, t b = univ) ∧ Sigma LocallyFinite t ∧ ∀ b, ∃ a, t b ⊆ s a

end PiBase

namespace PiBase.Formal

def P115 : Property where
  toPred := SubparacompactSpace
  well_defined φ h := sorry

end PiBase.Formal

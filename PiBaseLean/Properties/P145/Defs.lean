module

public import PiBaseLean.AdditionalDefs.Cover
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace PiBase.AdditionalDefs

universe u

namespace PiBase

/- 145. Strongly paracompact -/
class StronglyParacompactSpace (X : Type u) [TopologicalSpace X] : Prop where
  starFinite_refinement :
    ∀ (α : Type u) (s : α → Set X), (∀ a, IsOpen (s a)) → (⋃ a, s a = univ) →
      ∃ (β : Type u) (t : β → Set X),
        (∀ b, IsOpen (t b)) ∧ (⋃ b, t b = univ) ∧ StarFinite t ∧ ∀ b, ∃ a, t b ⊆ s a

end PiBase

namespace PiBase.Formal

def P145 : Property where
  toPred := StronglyParacompactSpace
  well_defined φ h := sorry

end PiBase.Formal

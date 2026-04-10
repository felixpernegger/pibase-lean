module

public import PiBaseLean.AdditionalDefs
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace PiBase.AdditionalDefs

universe u

namespace PiBase

/- 31. Metacompact -/
class MetacompactSpace (X : Type u) [TopologicalSpace X] : Prop where
  metacompact :
    ∀ (α : Type u) (s : α → Set X), (∀ a, IsOpen (s a)) → (⋃ a, s a = univ) →
      ∃ (β : Type u) (t : β → Set X),
        (∀ b, IsOpen (t b)) ∧ (⋃ b, t b = univ) ∧ PointFinite t ∧ ∀ b, ∃ a, t b ⊆ s a

end PiBase

namespace PiBase.Formal

def P31 : Property where
  toPred := MetacompactSpace
  well_defined φ h := sorry

end PiBase.Formal

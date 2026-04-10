module

public import PiBaseLean.AdditionalDefs.Cover
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

universe u

open Topology Set Function Filter TopologicalSpace PiBase.AdditionalDefs

namespace PiBase

/- 33. Countably metacompact -/
class CountablyMetacompactSpace (X : Type u) [TopologicalSpace X] : Prop where
  countably_metacompact :
    ∀ (α : Type u) (s : α → Set X), (∀ a, IsOpen (s a)) → (⋃ a, s a = univ) →
      ∃ (β : Type u) (t : β → Set X), Countable β →
        (∀ b, IsOpen (t b)) ∧ (⋃ b, t b = univ) ∧ PointFinite t ∧ ∀ b, ∃ a, t b ⊆ s a

end PiBase

namespace PiBase.Formal

def P33 : Property where
  toPred := CountablyMetacompactSpace
  well_defined φ h := sorry

end PiBase.Formal

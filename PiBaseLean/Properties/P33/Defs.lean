module

public import PiBaseLean.AdditionalDefs.Cover

@[expose] public section

universe u

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 33. Countably metacompact -/
class CountablyMetacompactSpace (X : Type u) [TopologicalSpace X] : Prop where
  countably_metacompact :
    ∀ (α : Type u) (s : α → Set X), (∀ a, IsOpen (s a)) → (⋃ a, s a = univ) → Countable α →
      ∃ (β : Type u) (t : β → Set X),
        (∀ b, IsOpen (t b)) ∧ (⋃ b, t b = univ) ∧ PointFinite t ∧ ∀ b, ∃ a, t b ⊆ s a

end PiBase

module

public import Mathlib.Topology.LocallyFinite

@[expose] public section

universe u

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 32. Countably paracompact -/
class CountablyParacompactSpace (X : Type u) [TopologicalSpace X] : Prop where
  countably_paracompact :
    ∀ (α : Type u) (s : α → Set X), (∀ a, IsOpen (s a)) → (⋃ a, s a = univ) → Countable α →
      ∃ (β : Type u) (t : β → Set X),
        (∀ b, IsOpen (t b)) ∧ (⋃ b, t b = univ) ∧ LocallyFinite t ∧ ∀ b, ∃ a, t b ⊆ s a

end PiBase

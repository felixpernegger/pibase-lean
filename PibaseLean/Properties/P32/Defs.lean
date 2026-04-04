import Mathlib.Topology.LocallyFinite

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 32. Countably paracompact -/
class CountablyParacompactSpace (X : Type v) [TopologicalSpace X] : Prop where
  countably_paracompact :
    ∀ (α : Type v) (s : α → Set X), (∀ a, IsOpen (s a)) → (⋃ a, s a = univ) →
      ∃ (β : Type v) (t : β → Set X), Countable β →
        (∀ b, IsOpen (t b)) ∧ (⋃ b, t b = univ) ∧ LocallyFinite t ∧ ∀ b, ∃ a, t b ⊆ s a

end PiBase

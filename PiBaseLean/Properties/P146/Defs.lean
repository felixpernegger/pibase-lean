module

public import Mathlib.Data.Setoid.Partition
public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

open Set

universe u

namespace PiBase

/- 146. Ultraparacompact -/
class UltraparacompactSpace (X : Type u) [TopologicalSpace X] : Prop where
  partition_refinement :
    ∀ (α : Type u) (s : α → Set X), (∀ a, IsOpen (s a)) → (⋃ a, s a = univ) →
      ∃ (β : Type u) (t : β → Set X),
        (∀ b, IsOpen (t b)) ∧ (Setoid.IsPartition (range t)) ∧ ∀ b : β, ∃ a : α, t b ⊆ s a

end PiBase

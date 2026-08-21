module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P213.Bundled
public import PiBaseLean.Properties.P214.Bundled

@[expose] public section

universe u

open Set

namespace PiBase

/-- Theorem T736: P213 (α3Space) => P214 (α4Space) -/
instance instα4SpaceOfα3Space {X : Type u} [TopologicalSpace X] [h : α3Space X] :
    α4Space X where
  subset_converge := by
    intro x S S_inj hS
    obtain ⟨T, Ti, Tx, rT, hT⟩ := h.subset_converge S_inj hS
    refine ⟨T, Ti, Tx, rT, ?_⟩
    refine Set.Infinite.mono ?_ hT
    intro n hn
    simp only [mem_ofPred_eq] at hn ⊢
    exact Set.Infinite.nonempty hn

end PiBase

namespace PiBase.Formal

theorem T736 : P213 ≤ P214 := fun X _ ↦ @instα4SpaceOfα3Space X _

end PiBase.Formal

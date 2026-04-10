module

public import PiBaseLean.Properties.Bundled.Basic
public import Mathlib.Order.Filter.AtTopBot.Basic
public import PiBaseLean.Properties.P213.Defs
public import PiBaseLean.Properties.P214.Defs

@[expose] public section

universe u

open Topology Set Function Filter

namespace PiBase

/-- Theorem T736: P213 (α3Space) => P214 (α4Space) -/
instance instα4SpaceOfα3Space (X : Type u)
    [TopologicalSpace X] [h : α3Space X] :
    α4Space X where
  subset_converge := by
    intro x S S_inj hS
    obtain ⟨T, Tx, rT, hT⟩ := h.subset_converge S_inj hS
    obtain ⟨a, ha⟩ := eventually_atTop.mp hT
    exact ⟨T, Tx, rT, eventually_atTop.mpr ⟨a, fun b hb ↦ Set.Infinite.nonempty (ha b hb)⟩⟩

end PiBase

namespace PiBase.Formal

theorem T736 : P213 ≤ P214 := fun X _ ↦ @instα4SpaceOfα3Space X _

end PiBase.Formal

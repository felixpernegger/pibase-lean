module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P210.Defs
public import PiBaseLean.Properties.P211.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T733: P210 (α1Space) => P211 (α15Space) -/
instance instα15SpaceOfα1Space (X : Type u)
    [TopologicalSpace X] [h : α1Space X] :
    α15Space X where
  subset_converge := by
    intro x S S_inj S_disj hS
    obtain ⟨T, Tx, rT, hT⟩ := h.subset_converge S_inj hS
    refine ⟨T, Tx, rT, .of_forall hT⟩

end PiBase

namespace PiBase.Formal

theorem T733 : P210 ≤ P211 := fun X _ ↦ @instα15SpaceOfα1Space X _

end PiBase.Formal

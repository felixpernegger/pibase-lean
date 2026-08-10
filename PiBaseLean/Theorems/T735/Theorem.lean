module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P212.Defs
public import PiBaseLean.Properties.P213.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T735: P212 (α2Space) => P213 (α3Space) -/
instance instα3SpaceOfα2Space (X : Type u)
    [TopologicalSpace X] [h : α2Space X] :
    α3Space X where
  subset_converge := by
    intro x S S_inj hS
    obtain ⟨T, Ti, Tx, rT, hT⟩ := h.subset_converge S_inj hS
    refine ⟨T, Ti, Tx, rT, ?_⟩
    convert Set.infinite_univ
    · ext a
      simp [hT a]
    · infer_instance

end PiBase

namespace PiBase.Formal

theorem T735 : P212 ≤ P213 := fun X _ ↦ @instα3SpaceOfα2Space X _

end PiBase.Formal

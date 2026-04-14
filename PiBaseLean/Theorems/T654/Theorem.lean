module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P18.Defs
public import PiBaseLean.Properties.P105.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T654: P18 (LindelofSpace) => P105 (ParaLindelofSpace) -/
instance instParaLindelofSpaceOfLindelofSpace (X : Type u)
    [TopologicalSpace X] [h : LindelofSpace X] :
    ParaLindelofSpace X where
  para_lindelof α s so sc := by
    obtain ⟨r, rc, hr⟩ := h.isLindelof_univ.elim_countable_subcover s so (by rw [sc])
    let g : r → Set X := fun l ↦ s l.val
    refine ⟨r, fun l ↦ s l.val, ?_, ?_, ?_, ?_⟩
    · simp_all
    · simp only [iUnion_coe_set]
      exact (hr.antisymm <| subset_univ _).symm
    · apply Countable.locallyCountable
      simpa
    · intro ⟨b, _⟩
      use b

end PiBase

namespace PiBase.Formal

theorem T654 : P18 ≤ P105 := fun X _ ↦ @instParaLindelofSpaceOfLindelofSpace X _

end PiBase.Formal

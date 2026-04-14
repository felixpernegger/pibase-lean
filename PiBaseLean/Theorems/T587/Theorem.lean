module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P18.Defs
public import PiBaseLean.Properties.P83.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

-- Most likely redundant
/-- Theorem T587: P18 (LindelofSpace) => P83 (MetaLindelofSpace) -/
instance instMetaLindelofSpaceOfLindelofSpace (X : Type u)
    [TopologicalSpace X] [h : LindelofSpace X] :
    MetaLindelofSpace X where
  meta_lindelof ι s so sc := by
    obtain ⟨t, tc, t_cov⟩ := h.isLindelof_univ.elim_countable_subcover s so (univ_subset_iff.mpr sc)
    refine ⟨t, fun r ↦ s r.val, ?_, ?_, ?_, ?_⟩
    · simp only [Subtype.forall]
      exact fun a _ ↦ so a
    · simp_all
    · apply LocallyCountable.pointCountable
      apply Countable.locallyCountable
      simpa
    · intro ⟨b, _⟩
      use b

end PiBase

namespace PiBase.Formal

theorem T587 : P18 ≤ P83 := fun X _ ↦ @instMetaLindelofSpaceOfLindelofSpace X _

end PiBase.Formal

module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P18.Defs
public import PiBaseLean.Properties.P62.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T128: P18 (LindelofSpace) => P62 (WeaklyLindelofSpace) -/
instance instWeaklyLindelofSpaceOfLindelofSpace (X : Type u)
    [TopologicalSpace X] [h : LindelofSpace X] :
    WeaklyLindelofSpace X where
  weakly_lindelof := by
    intro ι U U_open U_cover
    obtain ⟨r, rc, hr⟩ := h.isLindelof_univ.elim_countable_subcover (ι := ι) U U_open
      <| univ_subset_iff.mpr U_cover
    exact ⟨r, rc, by simp_all⟩

end PiBase

namespace PiBase.Formal

theorem T128 : P18 ≤ P62 := fun X _ ↦ @instWeaklyLindelofSpaceOfLindelofSpace X _

end PiBase.Formal

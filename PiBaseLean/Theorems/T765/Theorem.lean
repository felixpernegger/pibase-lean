module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P13.Defs
public import PiBaseLean.Properties.P218.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T765: P218 (UltranormalSpace) => P13 (NormalSpace) -/
instance instNormalSpaceOfUltranormalSpace (X : Type u)
    [TopologicalSpace X] [h : UltranormalSpace X] :
    NormalSpace X where
  normal s t hs ht st := by
    obtain ⟨r, hr, sr, tr⟩ := h.disjoint_clopen st hs ht
    exact ⟨r, rᶜ, hr.isOpen, isOpen_compl_iff.mpr hr.isClosed, sr, tr,
      HasSubset.Subset.disjoint_compl_right fun ⦃_⦄ a ↦ a⟩

end PiBase

namespace PiBase.Formal

theorem T765 : P218 ≤ P13 := fun X _ ↦ @instNormalSpaceOfUltranormalSpace X _

end PiBase.Formal

module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P172.Defs
public import PiBaseLean.Properties.P173.Defs

@[expose] public section

universe u

open Topology Set Function PiBase.AdditionalDefs

namespace PiBase

/-- Theorem T205: P172 (RadialSpace) => P173 (PseudoradialSpace)
TODO: Shorten this by using alternative def for PseudoRadial -/
instance instPseudoradialSpaceOfRadialSpace (X : Type u)
    [TopologicalSpace X] [h : RadialSpace X] :
    PseudoradialSpace X where
  radiallyClosed_isClosed s hs := by
    unfold IsRadiallyClosed at hs
    contrapose! hs
    have : (closure s \ s).Nonempty := by
      apply nonempty_of_ssubset <| Set.ssubset_iff_subset_ne.mpr ⟨subset_closure, ?_⟩
      contrapose! hs
      exact closure_eq_iff_isClosed.mp <| Eq.symm hs
    obtain ⟨r, rc, rs⟩ := this
    exact ⟨r, h.ex_seq s r rc, rs⟩

end PiBase

namespace PiBase.Formal

theorem T205 : P172 ≤ P173 := fun X _ ↦ @instPseudoradialSpaceOfRadialSpace X _

end PiBase.Formal

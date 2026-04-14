module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P66.Defs
public import PiBaseLean.Properties.P68.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T160: P68 (RothbergerSpace) => P66 (MengerSpace) -/
instance instMengerSpaceOfRothbergerSpace (X : Type u)
    [TopologicalSpace X] [h : RothbergerSpace X] :
    MengerSpace X where
  menger := by
    intro ι U hU U_cover
    obtain ⟨j, hj⟩ := h.rothberger U hU U_cover
    refine ⟨fun n ↦ {j n}, ?_⟩
    simpa

end PiBase

namespace PiBase.Formal

theorem T160 : P68 ≤ P66 := fun X _ ↦ @instMengerSpaceOfRothbergerSpace X _

end PiBase.Formal

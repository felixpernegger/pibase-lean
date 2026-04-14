module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P153.Defs
public import PiBaseLean.Properties.P150.Defs
public import PiBaseLean.Theorems.T160.Theorem

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T359: P150 (OmegaRothberger) => P153 (OmegaMengerSpace) -/
instance instOmegaMengerSpaceOfOmegaRothberger (X : Type u)
    [TopologicalSpace X] [h : OmegaRothberger X] :
    OmegaMengerSpace X where
    omega_menger := by
      apply omega_of_imp (Q := MengerSpace) ?_ h.omega_rothberger
      intros
      apply instMengerSpaceOfRothbergerSpace

end PiBase

namespace PiBase.Formal

theorem T359 : P150 ≤ P153 := fun X _ ↦ @instOmegaMengerSpaceOfOmegaRothberger X _

end PiBase.Formal

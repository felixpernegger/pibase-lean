module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P66.Defs
public import PiBaseLean.Properties.P66.Lemmas
public import PiBaseLean.Properties.P153.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T362: P153 (OmegaMengerSpace) => P66 (MengerSpace) -/
instance instMengerSpaceOfOmegaMengerSpace (X : Type u)
    [TopologicalSpace X] [h : OmegaMengerSpace X] :
    MengerSpace X := h.omega_menger.toProperty WellDefined.mengerSpace

end PiBase

namespace PiBase.Formal

theorem T362 : P153 ≤ P66 := fun X _ ↦ @instMengerSpaceOfOmegaMengerSpace X _

end PiBase.Formal

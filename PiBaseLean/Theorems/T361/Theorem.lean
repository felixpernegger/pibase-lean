module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P68.Defs
public import PiBaseLean.Properties.P68.Lemmas
public import PiBaseLean.Properties.P150.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T361: P150 (OmegaRothberger) => P68 (RothbergerSpace) -/
instance instRothbergerSpaceOfOmegaRothberger (X : Type u)
    [TopologicalSpace X] [h : OmegaRothberger X] :
    RothbergerSpace X := h.omega_rothberger.toProperty WellDefined.rothbergerSpace

end PiBase

namespace PiBase.Formal

theorem T361 : P150 ≤ P68 := fun X _ ↦ @instRothbergerSpaceOfOmegaRothberger X _

end PiBase.Formal

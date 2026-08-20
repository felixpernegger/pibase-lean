module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P18.Bundled
public import PiBaseLean.Properties.P18.Bundled
public import PiBaseLean.Properties.P149.Bundled

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T360: P149 (OmegaLindelof) => P18 (LindelofSpace) -/
instance instLindelofSpaceOfOmegaLindelof (X : Type u) [TopologicalSpace X] [h : OmegaLindelof X] :
    LindelofSpace X := Omega.toProperty WellDefined.lindelofSpace h.omega_lindelof

end PiBase

namespace PiBase.Formal

theorem T360 : P149 ≤ P18 := fun X _ ↦ @instLindelofSpaceOfOmegaLindelof X _

end PiBase.Formal

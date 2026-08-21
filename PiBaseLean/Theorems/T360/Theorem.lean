module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P149.Bundled
public import PiBaseLean.Properties.P18.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T360: P149 (OmegaLindelof) => P18 (LindelofSpace) -/
instance instLindelofSpaceOfOmegaLindelof {X : Type u} [TopologicalSpace X] [h : OmegaLindelof X] :
    LindelofSpace X := Omega.toProperty WellDefined.lindelofSpace h.omega_lindelof

end PiBase

namespace PiBase.Formal

theorem T360 : P149 ≤ P18 := fun X _ ↦ @instLindelofSpaceOfOmegaLindelof X _

end PiBase.Formal

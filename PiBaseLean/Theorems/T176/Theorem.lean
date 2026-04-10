module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P73.Defs
public import PiBaseLean.Properties.P75.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T176: P75 (SpectralSpace) => P73 (SoberSpace) -/
theorem instSoberSpaceOfSpectralSpace (X : Type u)
    [TopologicalSpace X] [SpectralSpace X] :
    SoberSpace X := by tauto

end PiBase

namespace PiBase.Formal

theorem T176 : P75 ≤ P73 := fun X _ ↦ @instSoberSpaceOfSpectralSpace X _

end PiBase.Formal

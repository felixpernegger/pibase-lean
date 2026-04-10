module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P73.Defs
public import PiBaseLean.Properties.P192.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T511: P73 (SoberSpace) => P192 (QuasiSober) -/
theorem instQuasiSoberOfSoberSpace (X : Type u)
    [TopologicalSpace X] [SoberSpace X] :
    QuasiSober X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T511 : P73 ≤ P192 := fun X _ ↦ @instQuasiSoberOfSoberSpace X _

end PiBase.Formal

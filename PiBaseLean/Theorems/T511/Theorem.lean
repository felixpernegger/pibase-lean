module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P192.Bundled
public import PiBaseLean.Properties.P73.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T511: P73 (SoberSpace) => P192 (QuasiSober) -/
theorem instQuasiSoberOfSoberSpace {X : Type u}
    [TopologicalSpace X] [SoberSpace X] :
    QuasiSober X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T511 : P73 ≤ P192 := fun X _ ↦ @instQuasiSoberOfSoberSpace X _

end PiBase.Formal

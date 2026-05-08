module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P134.Defs
public import PiBaseLean.Properties.P192.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T519: P134 (R1Space) => P192 (QuasiSober) -/
theorem instQuasiSoberOfR1Space (X : Type u)
    [TopologicalSpace X] [R1Space X] : QuasiSober X := by
  infer_instance

end PiBase

namespace PiBase.Formal

theorem T519 : P134 ≤ P192 := fun X _ _ ↦ by
  simp_all only [P134, P192]
  infer_instance

end PiBase.Formal

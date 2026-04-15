module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P13.Defs
public import PiBaseLean.Properties.P14.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T36: P14 (CompletelyNormalSpace) => P13 (NormalSpace) -/
theorem instNormalSpaceOfCompletelyNormalSpace (X : Type u)
    [TopologicalSpace X] [CompletelyNormalSpace X] : NormalSpace X := by
  infer_instance

end PiBase

namespace PiBase.Formal

theorem T36 : P14 ≤ P13 := fun X _ _ ↦ by
  simp_all only [P14, P13]
  infer_instance

end PiBase.Formal

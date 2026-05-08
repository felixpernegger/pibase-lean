module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P6.Defs
public import PiBaseLean.Properties.P12.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T149: P6 (T35Space) => P12 (CompletelyRegularSpace) -/
theorem instCompletelyRegularSpaceOfT35Space (X : Type u)
    [TopologicalSpace X] [T35Space X] : CompletelyRegularSpace X := by
  infer_instance

end PiBase

namespace PiBase.Formal

theorem T149 : P6 ≤ P12 := fun X _ _ ↦ by
  simp_all only [P6, P12]
  infer_instance

end PiBase.Formal

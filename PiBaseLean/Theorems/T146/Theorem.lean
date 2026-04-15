module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P5.Defs
public import PiBaseLean.Properties.P11.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T146: P5 (T3Space) => P11 (RegularSpace) -/
theorem instRegularSpaceOfT3Space (X : Type u) [TopologicalSpace X] [T3Space X] :
    RegularSpace X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T146 : P5 ≤ P11 := fun X _ _ ↦ by
  simp_all only [P5, P11]
  infer_instance

end PiBase.Formal

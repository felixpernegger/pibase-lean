module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P7.Defs
public import PiBaseLean.Properties.P13.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T335: P7 (T4Space) => P13 (NormalSpace) -/
theorem instNormalSpaceOfT4Space (X : Type u)
    [TopologicalSpace X] [T4Space X] :
    NormalSpace X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T335 : P7 ≤ P13 := fun X _ ↦ @instNormalSpaceOfT4Space X _

end PiBase.Formal

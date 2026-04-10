module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P8.Defs
public import PiBaseLean.Properties.P14.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T336: P8 (T5Space) => P14 (CompletelyNormalSpace) -/
theorem instCompletelyNormalSpaceOfT5Space (X : Type u)
    [TopologicalSpace X] [T5Space X] :
    CompletelyNormalSpace X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T336 : P8 ≤ P14 := fun X _ ↦ @instCompletelyNormalSpaceOfT5Space X _

end PiBase.Formal

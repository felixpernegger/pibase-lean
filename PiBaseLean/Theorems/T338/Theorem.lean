module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P15.Defs
public import PiBaseLean.Properties.P67.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T338: P67 (T6Space) => P15 (PerfectlyNormalSpace) -/
theorem instPerfectlyNormalSpaceOfT6Space (X : Type u)
    [TopologicalSpace X] [T6Space X] :
    PerfectlyNormalSpace X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T338 : P67 ≤ P15 := fun X _ ↦ @instPerfectlyNormalSpaceOfT6Space X _

end PiBase.Formal

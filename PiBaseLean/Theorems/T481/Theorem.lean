module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P3.Defs
public import PiBaseLean.Properties.P188.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T481: P188 (ContinuumSpace) => P3 (T2Space) -/
theorem instT2SpaceOfContinuumSpace (X : Type u)
    [TopologicalSpace X] [ContinuumSpace X] :
    T2Space X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T481 : P188 ≤ P3 := fun X _ ↦ @instT2SpaceOfContinuumSpace X _

end PiBase.Formal

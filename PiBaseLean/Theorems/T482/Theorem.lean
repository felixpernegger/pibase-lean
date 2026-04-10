module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P16.Defs
public import PiBaseLean.Properties.P188.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T482: P188 (ContinuumSpace) => P16 (CompactSpace) -/
theorem instCompactSpaceOfContinuumSpace (X : Type u)
    [TopologicalSpace X] [ContinuumSpace X] :
    CompactSpace X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T482 : P188 ≤ P16 := fun X _ ↦ @instCompactSpaceOfContinuumSpace X _

end PiBase.Formal

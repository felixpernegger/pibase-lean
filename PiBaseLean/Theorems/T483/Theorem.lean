module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P36.Defs
public import PiBaseLean.Properties.P188.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

-- Most likely redundant
/-- Theorem T483: P188 (ContinuumSpace) => P36 (PreconnectedSpace) -/
theorem instPreconnectedSpaceOfContinuumSpace (X : Type u)
    [TopologicalSpace X] [ContinuumSpace X] :
    PreconnectedSpace X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T483 : P188 ≤ P36 := fun X _ ↦ @instPreconnectedSpaceOfContinuumSpace X _

end PiBase.Formal

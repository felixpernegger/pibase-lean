module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P16.Defs
public import PiBaseLean.Properties.P77.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T457: P77 (CorsonCompactSpace) => P16 (CompactSpace) -/
theorem instCompactSpaceOfCorsonCompactSpace (X : Type u)
    [TopologicalSpace X] [CorsonCompactSpace X] :
    CompactSpace X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T457 : P77 ≤ P16 := fun X _ ↦ @instCompactSpaceOfCorsonCompactSpace X _

end PiBase.Formal

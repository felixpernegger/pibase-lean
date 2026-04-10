module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P16.Defs
public import PiBaseLean.Properties.P17.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T121: P16 (CompactSpace) => P17 (SigmaCompactSpace) -/
theorem instSigmaCompactSpaceOfCompactSpace (X : Type u)
    [TopologicalSpace X] [CompactSpace X] :
    SigmaCompactSpace X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T121 : P16 ≤ P17 := fun X _ ↦ @instSigmaCompactSpaceOfCompactSpace X _

end PiBase.Formal

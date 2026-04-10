module

public import Mathlib.Topology.NoetherianSpace
public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P16.Defs
public import PiBaseLean.Properties.P208.Defs

@[expose] public section

universe u

open Topology Set Function TopologicalSpace

namespace PiBase

/-- Theorem T650: P208 (NoetherianSpace) => P16 (CompactSpace) -/
theorem instCompactSpaceOfNoetherianSpace (X : Type u)
    [TopologicalSpace X] [NoetherianSpace X] :
    CompactSpace X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T650 : P208 ≤ P16 := fun X _ ↦ @instCompactSpaceOfNoetherianSpace X _

end PiBase.Formal

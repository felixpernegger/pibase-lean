module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P49.Defs
public import PiBaseLean.Properties.P119.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T803: P119 (StoneanSpace) => P49 (ExtremallyDisconnected) -/
theorem instExtremallyDisconnectedOfStoneanSpace (X : Type u)
    [TopologicalSpace X] [StoneanSpace X] :
    ExtremallyDisconnected X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T803 : P119 ≤ P49 := fun X _ ↦ @instExtremallyDisconnectedOfStoneanSpace X _

end PiBase.Formal

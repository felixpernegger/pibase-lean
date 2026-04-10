module

public import Mathlib.Topology.Bases
public import Mathlib.Topology.MetricSpace.Polish
public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P26.Defs
public import PiBaseLean.Properties.P116.Defs

@[expose] public section

universe u

open Topology Set Function TopologicalSpace

namespace PiBase

/-- Theorem T199: P116 (PolishSpace) => P26 (SeparableSpace) -/
theorem instSeparableSpaceOfPolishSpace (X : Type u)
    [TopologicalSpace X] [PolishSpace X] :
    SeparableSpace X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T199 : P116 ≤ P26 := fun X _ ↦ @instSeparableSpaceOfPolishSpace X _

end PiBase.Formal

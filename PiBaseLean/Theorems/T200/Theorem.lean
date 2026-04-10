module

public import PiBaseLean.Properties.Bundled.Basic
public import Mathlib.Topology.MetricSpace.Polish
public import Mathlib.Topology.Metrizable.CompletelyMetrizable
public import PiBaseLean.Properties.P55.Defs
public import PiBaseLean.Properties.P116.Defs

@[expose] public section

universe u

open Topology Set Function TopologicalSpace

namespace PiBase

/-- Theorem T200: P116 (PolishSpace) => P55 (IsCompletelyMetrizableSpace) -/
theorem instIsCompletelyMetrizableSpaceOfPolishSpace (X : Type u)
    [TopologicalSpace X] [PolishSpace X] :
    IsCompletelyMetrizableSpace X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T200 : P116 ≤ P55 := fun X _ ↦ @instIsCompletelyMetrizableSpaceOfPolishSpace X _

end PiBase.Formal

module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P52.Defs
public import PiBaseLean.Properties.P55.Defs
public import Mathlib.Topology.Metrizable.CompletelyMetrizable

@[expose] public section

universe u

open Topology Set Function TopologicalSpace

namespace PiBase

/-- Theorem T85: P52 (DiscreteTopology) => P55 (IsCompletelyMetrizableSpace) -/
theorem instIsCompletelyMetrizableSpaceOfDiscreteTopology (X : Type u)
    [TopologicalSpace X] [DiscreteTopology X] : IsCompletelyMetrizableSpace X := by
  infer_instance

end PiBase

namespace PiBase.Formal

theorem T85 : P52 ≤ P55 := fun X _ _ ↦ by
  simp_all only [P52, P55]
  infer_instance

end PiBase.Formal

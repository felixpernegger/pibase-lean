module

public import Mathlib.Topology.Constructions
public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P52.Defs
public import PiBaseLean.Properties.P219.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T817: P52 (DiscreteTopology) => P219 (TorontoSpace) -/
theorem instTorontoSpaceOfDiscreteTopology (X : Type u)
    [TopologicalSpace X] [h : DiscreteTopology X] :
    TorontoSpace X := by
  refine ⟨fun _ h ↦ ⟨Cardinal.eq.mp h |>.some, ?_, ?_⟩⟩
  <;> exact continuous_of_discreteTopology

end PiBase

namespace PiBase.Formal

theorem T817 : P52 ≤ P219 := fun X _ ↦ @instTorontoSpaceOfDiscreteTopology X _

end PiBase.Formal

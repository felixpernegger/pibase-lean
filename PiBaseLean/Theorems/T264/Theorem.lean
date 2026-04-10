module

public import PiBaseLean.Properties.Bundled.Basic
public import Mathlib.Topology.Metrizable.Basic
public import PiBaseLean.Properties.P53.Defs
public import PiBaseLean.Properties.P121.Defs

@[expose] public section

universe u

open Topology Set Function TopologicalSpace

namespace PiBase

/-- Theorem T264: P53 (MetrizableSpace) => P121 (PseudoMetrizableSpace) -/
theorem instPseudoMetrizableSpaceOfMetrizableSpace (X : Type u)
    [TopologicalSpace X] [MetrizableSpace X] :
    PseudoMetrizableSpace X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T264 : P53 ≤ P121 := fun X _ ↦ @instPseudoMetrizableSpaceOfMetrizableSpace X _

end PiBase.Formal

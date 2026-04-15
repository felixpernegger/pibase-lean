module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P53.Defs
public import PiBaseLean.Properties.P55.Defs
public import Mathlib.Topology.Metrizable.Basic

@[expose] public section

universe u

open Topology Set Function TopologicalSpace

namespace PiBase

/- Theorem T77: P55 (IsCompletelyMetrizableSpace) => P53 (MetrizableSpace) -/
#check PseudoMetrizableSpace.toMetrizableSpace

end PiBase

namespace PiBase.Formal

theorem T77 : P55 ≤ P53 := fun X _ _ ↦ by
  simp_all only [P55, P53]
  infer_instance

end PiBase.Formal

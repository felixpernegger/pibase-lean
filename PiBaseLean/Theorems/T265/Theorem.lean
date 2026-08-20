module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P1.Bundled
public import PiBaseLean.Properties.P53.Bundled
public import PiBaseLean.Properties.P121.Bundled
public import Mathlib.Topology.Metrizable.Basic

@[expose] public section

universe u

open Topology Set Function TopologicalSpace

namespace PiBase

/- Theorem T265: P121 (PseudoMetrizableSpace) + P1 (T0Space) => P53 (MetrizableSpace) -/
#check PseudoMetrizableSpace.toMetrizableSpace

end PiBase

namespace PiBase.Formal

theorem T265 : P121 ⊓ P1 ≤ P53 := fun X _ ⟨_, _⟩ ↦ by
  simp_all only [P121, P1, P53]
  infer_instance

end PiBase.Formal

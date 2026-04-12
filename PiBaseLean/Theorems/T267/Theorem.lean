module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P2.Defs
public import PiBaseLean.Properties.P52.Defs
public import PiBaseLean.Properties.P90.Defs
public import Mathlib.Topology.Separation.AlexandrovDiscrete

@[expose] public section

universe u

open Topology Set Function

namespace PiBase.Formal

/-- Theorem T267: P90 (AlexandrovDiscrete) + P2 (T1Space) => P52 (DiscreteTopology) -/
theorem T267 : P90 ⊓ P2 ≤ P52 := fun X _ ⟨_, _⟩ ↦ by
  simp_all only [P90, P2, P52]
  infer_instance

end PiBase.Formal

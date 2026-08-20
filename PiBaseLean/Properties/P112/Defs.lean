module

public import Mathlib.Topology.MetricSpace.Basic
public import Mathlib.Topology.Homeomorph.Lemmas

@[expose] public section

open Topology Set TopologicalSpace

universe u

namespace PiBase

/- 112. Submetrizable space -/
class SubmetrizableSpace (X : Type*) [τ : TopologicalSpace X] : Prop where
  le_metrizable : ∃ m : MetricSpace X, τ ≤ m.toUniformSpace.toTopologicalSpace

end PiBase

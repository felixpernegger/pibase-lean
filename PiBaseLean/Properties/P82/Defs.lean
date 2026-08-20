module

public import Mathlib.Topology.Metrizable.Basic
public import Mathlib.Topology.Homeomorph.Lemmas

@[expose] public section

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 82. Locally metrizable -/
class LocallyMetrizableSpace (X : Type*) [TopologicalSpace X] : Prop where
  locally_metrizable : ∀ (x : X), ∃ C ∈ 𝓝 x, MetrizableSpace C

end PiBase

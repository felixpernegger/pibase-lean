module

public import Mathlib.Topology.Homeomorph.Lemmas

@[expose] public section

open Topology

namespace PiBase

/- 84. Locally T2 -/
class LocallyT2Space (X : Type*) [TopologicalSpace X] : Prop where
  locally_t2 : ∀ (x : X), ∃ C ∈ 𝓝 x, T2Space C

end PiBase

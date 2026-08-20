module

public import Mathlib.Data.Finite.Defs
public import Mathlib.Topology.Defs.Filter

@[expose] public section

open Topology Filter

namespace PiBase

/- 94. Locally finite -/
class LocallyFiniteSpace (X : Type*) [TopologicalSpace X] : Prop where
  locally_finite : ∀ x : X, ∃ s ∈ 𝓝 x, s.Finite

end PiBase

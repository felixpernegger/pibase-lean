module

public import Mathlib.Data.Set.Countable
public import Mathlib.Topology.Defs.Filter

@[expose] public section

open Topology

namespace PiBase

/- 93. Locally countable -/
class LocallyCountableSpace (X : Type*) [TopologicalSpace X] : Prop where
  locally_countable : ∀ x : X, ∃ s ∈ 𝓝 x, s.Countable

end PiBase

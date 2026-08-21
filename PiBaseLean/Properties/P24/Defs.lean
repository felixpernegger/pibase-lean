module

public import Mathlib.Topology.Homeomorph.Lemmas

@[expose] public section

open Topology

namespace PiBase

/- 24. Locally relatively compact -/
class LocallyRelativelyCompactSpace (X : Type*) [TopologicalSpace X] : Prop where
  locally_relatively_compact : ∀ x : X, (𝓝 x).HasBasis (fun s => s ∈ 𝓝 x ∧ IsCompact (closure s)) id

end PiBase

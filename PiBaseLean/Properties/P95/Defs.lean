module

public import Mathlib.Topology.Path

@[expose] public section

open Topology Set Function

namespace PiBase

/- 95. Arc connected -/
class ArcConnectedSpace (X : Type*) [TopologicalSpace X] : Prop where
  joined : Pairwise fun x y : X ↦ ∃ f : Path x y, IsEmbedding f

end PiBase

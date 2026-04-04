import Mathlib.Topology.Path

open Topology

namespace PiBase

/- 95. Arc connected -/
class ArcConnectedSpace (X : Type*) [TopologicalSpace X] : Prop where
  joined : Pairwise fun x y : X ↦ ∃ f : Path x y, IsEmbedding f

end PiBase

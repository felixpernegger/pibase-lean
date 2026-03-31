import Mathlib

open Topology Set Function Filter TopologicalSpace

namespace UnstablePiBase

/- 95. Arc connected -/
class ArcConnectedSpace (X : Type*) [TopologicalSpace X] : Prop where
  joined : Pairwise fun x y : X ↦ ∃ f : Path x y, IsEmbedding f

end UnstablePiBase

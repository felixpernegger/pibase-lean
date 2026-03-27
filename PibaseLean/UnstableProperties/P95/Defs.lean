import Mathlib

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 95. Arc connected -/
class ArcConnectedSpace (X : Type*) [TopologicalSpace X] : Prop where
  nonempty : Nonempty X
  joined : Pairwise fun x y : X ↦
    ∃ f : Icc (0 : ℝ) 1 → X, IsEmbedding f ∧ f 0 = x ∧ f 1 = y

end PiBase

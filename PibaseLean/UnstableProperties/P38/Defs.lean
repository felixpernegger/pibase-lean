import Mathlib

open Topology Set Function

namespace UnstablePiBase

/- 38. Injectively path connected -/
class InjPathConnectedSpace (X : Type*) [TopologicalSpace X] : Prop where
  joined : Pairwise fun x y : X ↦ ∃ f : Path x y, Injective f

end UnstablePiBase

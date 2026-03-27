import Mathlib

open Topology Set Function Filter TopologicalSpace

namespace UnstablePiBase

/- 106. Has a Gδ diagonal -/
class HasGδDiagonal (X : Type*) [TopologicalSpace X] : Prop where
  has_g_delta_diagonal : IsGδ (diagonal X)

end UnstablePiBase

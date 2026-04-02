import Mathlib.Topology.GDelta.Basic

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 106. Has a Gδ diagonal -/
class HasGδDiagonal (X : Type*) [TopologicalSpace X] : Prop where
  has_g_delta_diagonal : IsGδ (diagonal X)

end PiBase

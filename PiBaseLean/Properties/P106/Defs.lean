import Mathlib.Topology.GDelta.Basic

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 106. Has a Gδ diagonal -/
class HasGδDiagonal (X : Type*) [TopologicalSpace X] : Prop where
  has_g_delta_diagonal : IsGδ (diagonal X)

end PiBase

namespace PiBase.Formal

abbrev P106 := HasGδDiagonal

class NP106 (X : Type*) [TopologicalSpace X] where
  not_p106 : ¬ P106 X

end PiBase.Formal

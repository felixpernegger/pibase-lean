module

public import Mathlib.Topology.Constructions.SumProd
public import Mathlib.Topology.GDelta.Basic

@[expose] public section

open Set

namespace PiBase

/- 106. Has a Gδ diagonal -/
class HasGδDiagonal (X : Type*) [TopologicalSpace X] : Prop where
  has_g_delta_diagonal : IsGδ (diagonal X)

end PiBase

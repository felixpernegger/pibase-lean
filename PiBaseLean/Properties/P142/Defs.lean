module

public import Mathlib.Topology.Compactness.CompactlyCoherentSpace

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 142. k₃-space -/
class K3Space (X : Type u) [TopologicalSpace X] : Prop where
  isCoherentWith : IsCoherentWith {K : Set X | T2Space K ∧ IsCompact K}

end PiBase

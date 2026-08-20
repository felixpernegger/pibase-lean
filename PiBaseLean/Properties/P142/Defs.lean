module

public import Mathlib.Topology.Compactness.CompactlyCoherentSpace
public import Mathlib.Topology.Homeomorph.Lemmas
public import Mathlib.Topology.Separation.Hausdorff

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 142. k₃-space -/
class K3Space (X : Type u) [TopologicalSpace X] : Prop where
  isCoherentWith : IsCoherentWith {K : Set X | T2Space K ∧ IsCompact K}

end PiBase

module

public import Mathlib.Topology.Compactness.CompactlyCoherentSpace
public import Mathlib.Topology.Separation.Hausdorff
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 142. k₃-space -/
class K3Space (X : Type u) [TopologicalSpace X] : Prop where
  isCoherentWith : IsCoherentWith {K : Set X | T2Space K ∧ IsCompact K}

end PiBase

namespace PiBase.Formal

def P142 : Property where
  toPred := K3Space
  well_defined φ h := sorry

end PiBase.Formal

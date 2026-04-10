module

public import Mathlib.Topology.Separation.Hausdorff
public import PiBaseLean.Properties.P100.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 170. k₁-Hausdorff -/
class K1T2Space (X : Type u) [TopologicalSpace X] : Prop where
  compact_t2 (s : Set X) : IsCompact s → T2Space s

end PiBase

namespace PiBase.Formal

def P170 : Property where
  toPred := K1T2Space
  well_defined φ h := sorry

end PiBase.Formal

module

public import PiBaseLean.Properties.P100.Defs
public import Mathlib.Topology.Compactness.LocallyCompact

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 170. k₁-Hausdorff -/
class K1T2Space (X : Type u) [TopologicalSpace X] : Prop extends KcSpace X, LocallyCompactSpace X

end PiBase

namespace PiBase.Formal

def P170 : Property where
  toPred := K1T2Space
  well_defined φ h := sorry

end PiBase.Formal

module

public import Mathlib.Topology.Compactness.CompactlyGeneratedSpace
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 141. k₂-space -/
#check CompactlyGeneratedSpace

end PiBase

namespace PiBase.Formal

def P141 : Property where
  toPred := CompactlyGeneratedSpace
  well_defined φ h := sorry

end PiBase.Formal

module

public import Mathlib.Topology.Compactness.CompactlyCoherentSpace
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace

open scoped Set.Notation

universe u

namespace PiBase

/- 140. k₁-space -/
#check CompactlyCoherentSpace

end PiBase

namespace PiBase.Formal

def P140 : Property where
  toPred := CompactlyCoherentSpace
  well_defined φ h := sorry

end PiBase.Formal

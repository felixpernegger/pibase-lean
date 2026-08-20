module

public import Mathlib.Topology.Compactness.CompactlyCoherentSpace
public import Mathlib.Topology.Homeomorph.Lemmas

@[expose] public section

open Topology Set Function Filter TopologicalSpace

open scoped Set.Notation

universe u

namespace PiBase

/- 140. k₁-space -/
#guard_msgs (drop info) in
#check CompactlyCoherentSpace

end PiBase

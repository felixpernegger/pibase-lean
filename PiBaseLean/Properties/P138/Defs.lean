module

public import Mathlib.Topology.ContinuousMap.Basic
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function TopologicalSpace

universe u

namespace PiBase

/- 138. Countably many continuous self-maps -/
class CountablyManyContinuousSelfMaps (X : Type u) [TopologicalSpace X] : Prop where
  countable_self_maps : Countable C(X, X)

end PiBase

namespace PiBase.Formal

def P138 : Property where
  toPred := CountablyManyContinuousSelfMaps
  well_defined φ h := sorry

end PiBase.Formal

module

public import Mathlib.Topology.ContinuousMap.Basic

@[expose] public section

open Topology Set Function TopologicalSpace

universe u

namespace PiBase

/- 138. Countably many continuous self-maps -/
class CountablyManyContinuousSelfMaps (X : Type u) [TopologicalSpace X] : Prop where
  countable_self_maps : Countable C(X, X)

end PiBase

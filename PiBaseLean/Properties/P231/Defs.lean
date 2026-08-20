module

public import Mathlib.AlgebraicTopology.FundamentalGroupoid.SimplyConnected
public import Mathlib.Topology.Homeomorph.Lemmas

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 231. Weakly locally simply connected -/
class WeaklyLocallySimplyConnectedSpace (X : Type*) [TopologicalSpace X] : Prop where
  simply_connected_nbhd (x : X) : ∃ U ∈ 𝓝 x, SimplyConnectedSpace U

end PiBase

import Mathlib.AlgebraicTopology.FundamentalGroupoid.SimplyConnected

open Topology

namespace PiBase

/- 231. Weakly locally simply connected -/
class WeaklyLocallySimplyConnectedSpace (X : Type*) [TopologicalSpace X] : Prop where
  simply_connected_nbhd (x : X) : ∃ U ∈ 𝓝 x, SimplyConnectedSpace U

end PiBase

module

public import Mathlib.AlgebraicTopology.FundamentalGroupoid.SimplyConnected
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology

namespace PiBase

/- 231. Weakly locally simply connected -/
class WeaklyLocallySimplyConnectedSpace (X : Type*) [TopologicalSpace X] : Prop where
  simply_connected_nbhd (x : X) : ∃ U ∈ 𝓝 x, SimplyConnectedSpace U

end PiBase

namespace PiBase.Formal

def P231 : Property where
  toPred := WeaklyLocallySimplyConnectedSpace
  well_defined φ h := sorry

end PiBase.Formal

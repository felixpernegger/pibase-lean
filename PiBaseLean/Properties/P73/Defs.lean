module

public import Mathlib.Topology.Sober

@[expose] public section

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 73. Sober -/
class SoberSpace (X : Type*) [TopologicalSpace X] : Prop extends QuasiSober X, T0Space X

end PiBase

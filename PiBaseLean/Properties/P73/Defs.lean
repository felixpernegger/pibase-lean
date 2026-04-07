module

public import Mathlib.Topology.Sober
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 73. Sober -/
class SoberSpace (X : Type*) [TopologicalSpace X] : Prop extends QuasiSober X, T0Space X

end PiBase

namespace PiBase.Formal

def P73 : Property where
  toPred := SoberSpace
  well_defined φ _ := @SoberSpace.mk _ _ φ.symm.isClosedEmbedding.quasiSober φ.t0Space

end PiBase.Formal

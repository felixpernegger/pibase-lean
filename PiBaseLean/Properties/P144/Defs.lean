module

public import Mathlib.Topology.Metrizable.Basic
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 144. Locally pseudometrizable -/
class LocallyPseudoMetrizableSpace (X : Type u) [TopologicalSpace X] : Prop where
  nbhd_pseudometrizable (x : X) : ∃ s ∈ 𝓝 x, PseudoMetrizableSpace s

end PiBase

namespace PiBase.Formal

def P144 : Property where
  toPred := LocallyPseudoMetrizableSpace
  well_defined φ h := sorry

end PiBase.Formal

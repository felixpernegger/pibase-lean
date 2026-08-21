module

public import Mathlib.Topology.Metrizable.Basic

@[expose] public section

open Topology TopologicalSpace

universe u

namespace PiBase

/- 144. Locally pseudometrizable -/
class LocallyPseudoMetrizableSpace (X : Type u) [TopologicalSpace X] : Prop where
  nbhd_pseudometrizable (x : X) : ∃ s ∈ 𝓝 x, PseudoMetrizableSpace s

end PiBase

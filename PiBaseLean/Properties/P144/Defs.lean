module

public import Mathlib.Topology.Metrizable.Basic
public import Mathlib.Topology.Homeomorph.Lemmas

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 144. Locally pseudometrizable -/
class LocallyPseudoMetrizableSpace (X : Type u) [TopologicalSpace X] : Prop where
  nbhd_pseudometrizable (x : X) : ∃ s ∈ 𝓝 x, PseudoMetrizableSpace s

end PiBase

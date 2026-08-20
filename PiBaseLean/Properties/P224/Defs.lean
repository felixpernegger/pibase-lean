module

public import Mathlib.Topology.Homotopy.Contractible
public import Mathlib.Topology.Homeomorph.Lemmas

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 224. Weakly locally contractible -/
class WeaklyLocallyContractibleSpace (X : Type u) [TopologicalSpace X] : Prop where
  weakly_locally_contractible (x : X) : ∃ s ∈ 𝓝 x, ContractibleSpace s

end PiBase

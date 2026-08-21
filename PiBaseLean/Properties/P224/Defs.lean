module

public import Mathlib.Topology.Homotopy.Contractible

@[expose] public section

open Topology

universe u

namespace PiBase

/- 224. Weakly locally contractible -/
class WeaklyLocallyContractibleSpace (X : Type u) [TopologicalSpace X] : Prop where
  weakly_locally_contractible (x : X) : ∃ s ∈ 𝓝 x, ContractibleSpace s

end PiBase

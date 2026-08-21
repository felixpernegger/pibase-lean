module

public import PiBaseLean.Properties.P199.Defs

@[expose] public section

open Topology

universe u

namespace PiBase

/- 223. Locally contractible -/
class LocallyContractibleSpace (X : Type u) [TopologicalSpace X] : Prop where
  locally_contractible (x : X) : (𝓝 x).HasBasis
    (fun (s : Set X) ↦ IsOpen s ∧ x ∈ s ∧ ContractibleSpace s) id

end PiBase

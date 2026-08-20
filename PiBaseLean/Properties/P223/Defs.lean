module

public import Mathlib.Order.Filter.Bases.Basic
public import Mathlib.Topology.Defs.Filter
public import Mathlib.Topology.Homeomorph.Lemmas
public import Mathlib.Topology.Homotopy.Contractible
public import PiBaseLean.Properties.P199.Defs

@[expose] public section

open Topology Set Function Filter

universe u

namespace PiBase

/- 223. Locally contractible -/
class LocallyContractibleSpace (X : Type u) [TopologicalSpace X] : Prop where
  locally_contractible (x : X) : (𝓝 x).HasBasis
    (fun (s : Set X) ↦ IsOpen s ∧ x ∈ s ∧ ContractibleSpace s) id

end PiBase

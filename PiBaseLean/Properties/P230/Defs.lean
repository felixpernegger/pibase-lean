module

public import Mathlib.AlgebraicTopology.FundamentalGroupoid.SimplyConnected
public import Mathlib.Order.Filter.Bases.Basic
public import Mathlib.Topology.Defs.Filter
public import Mathlib.Topology.Homeomorph.Lemmas

@[expose] public section

open Topology Set Function Filter

namespace PiBase

/- 230. Locally simply connected -/
class LocallySimplyConnectedSpace (X : Type*) [TopologicalSpace X] : Prop where
  simply_connected_basis (x : X) :
    (𝓝 x).HasBasis (fun s : Set X => x ∈ s ∧ IsOpen s ∧ SimplyConnectedSpace s) id

end PiBase

import Mathlib.AlgebraicTopology.FundamentalGroupoid.SimplyConnected

open Topology

namespace PiBase

/- 230. Locally simply connected -/
class LocallySimplyConnectedSpace (X : Type*) [TopologicalSpace X] : Prop where
  simply_connected_basis (x : X) :
    (𝓝 x).HasBasis (fun s : Set X => x ∈ s ∧ IsOpen s ∧ SimplyConnectedSpace s) id

end PiBase

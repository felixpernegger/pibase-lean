module

public import PiBaseLean.Properties.P95.Defs

@[expose] public section

open Topology

namespace PiBase

/- 96. Locally arc connected -/
class LocallyArcConnectedSpace (X : Type*) [TopologicalSpace X] : Prop where
  arc_connected_basis : ∀ x : X, (𝓝 x).HasBasis (fun s : Set X =>
    x ∈ s ∧ IsOpen s ∧ ArcConnectedSpace s) id

end PiBase

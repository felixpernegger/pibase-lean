import PibaseLean.Properties.P95.Defs

open Topology Filter TopologicalSpace

namespace PiBase

/- 96. Locally arc connected -/
class LocallyArcConnectedSpace (X : Type*) [TopologicalSpace X] : Prop where
  arc_connected_basis : ∀ x : X, (𝓝 x).HasBasis (fun s : Set X => s ∈ 𝓝 x ∧ ArcConnectedSpace s) id

end PiBase

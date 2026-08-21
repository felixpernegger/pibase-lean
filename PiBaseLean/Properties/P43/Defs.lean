module

public import PiBaseLean.Properties.P38.Defs

@[expose] public section

open Topology

namespace PiBase

/- 43. Locally injectively path conneced -/
class LocallyInjPathConnectedSpace (X : Type*) [TopologicalSpace X] : Prop where
  inj_path_connected_basis : ∀ x : X, (𝓝 x).HasBasis
    (fun s : Set X => x ∈ s ∧ IsOpen s ∧ IsInjPathConnected s) id

end PiBase

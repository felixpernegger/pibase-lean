import Mathlib
import PibaseLean.Properties.P38.Defs

open Topology Set Function

namespace PiBase

/- 43. Locally injectively path conneced -/
class LocallyInjPathConnectedSpace (X : Type*)
    [TopologicalSpace X] : Prop where
  inj_path_connected_basis : ∀ x : X, (𝓝 x).HasBasis
    (fun s : Set X => s ∈ 𝓝 x ∧ InjPathConnectedSpace s) id

end PiBase

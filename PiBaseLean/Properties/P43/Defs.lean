module

public import PiBaseLean.Properties.P38.Bundled
public import Mathlib.Order.Filter.Bases.Basic
public import Mathlib.Topology.Homeomorph.Lemmas
public import Mathlib.Topology.Defs.Filter

@[expose] public section

open Topology Set Function Filter

namespace PiBase

/- 43. Locally injectively path conneced -/
class LocallyInjPathConnectedSpace (X : Type*) [TopologicalSpace X] : Prop where
  inj_path_connected_basis : ∀ x : X, (𝓝 x).HasBasis
    (fun s : Set X => x ∈ s ∧ IsOpen s ∧ IsInjPathConnected s) id

end PiBase

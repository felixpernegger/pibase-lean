module

public import PiBaseLean.Properties.P95.Bundled
public import Mathlib.Order.Filter.Bases.Basic
public import Mathlib.Topology.Homeomorph.Lemmas
public import Mathlib.Topology.Defs.Filter

@[expose] public section

open Topology Set Function Filter

namespace PiBase

/- 96. Locally arc connected -/
class LocallyArcConnectedSpace (X : Type*) [TopologicalSpace X] : Prop where
  arc_connected_basis : ∀ x : X, (𝓝 x).HasBasis (fun s : Set X =>
    x ∈ s ∧ IsOpen s ∧ ArcConnectedSpace s) id

end PiBase

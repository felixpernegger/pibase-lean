import Mathlib

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 42. Locally path-connected -/
class LocallyPathConnectedSpace (X : Type*) [TopologicalSpace X] : Prop where
  locally_path_connected : ∀ x : X, ∃ s ∈ 𝓝 x, PathConnectedSpace s

end PiBase

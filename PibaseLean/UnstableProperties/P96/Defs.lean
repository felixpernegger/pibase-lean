import Mathlib
import PibaseLean.UnstableProperties.P95.Defs

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 96. Locally arc connected -/
class LocallyArcConnectedSpace (X : Type*) [TopologicalSpace X] : Prop where
  nonempty : Nonempty X
  joined : ∀ x : X, ∃ B : Set (Set X), generate B = 𝓝 x ∧ ∀ s ∈ B, ArcConnectedSpace s

end PiBase

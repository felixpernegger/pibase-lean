import Mathlib

open Topology Set Function Filter TopologicalSpace

namespace UnstablePiBase

/- 45. Has a dispersion point -/
class HasDispersionPoint (X : Type*) [TopologicalSpace X] : Prop where
  preconnected : PreconnectedSpace X
  ex_dispersion_point : ∃ p : X, IsTotallyDisconnected ({p}ᶜ)

end UnstablePiBase

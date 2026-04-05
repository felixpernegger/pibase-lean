import Mathlib.Topology.Connected.TotallyDisconnected

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 45. Has a dispersion point -/
class HasDispersionPoint (X : Type*) [TopologicalSpace X] extends PreconnectedSpace X where
  ex_dispersion_point : ∃ p : X, IsTotallyDisconnected ({p}ᶜ)

end PiBase

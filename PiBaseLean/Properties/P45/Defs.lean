import Mathlib.Topology.Connected.TotallyDisconnected
import PiBaseLean.Properties.Bundled.Defs

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 45. Has a dispersion point -/
class HasDispersionPoint (X : Type*) [TopologicalSpace X] extends ConnectedSpace X where
  ex_dispersion_point : ∃ p : X, IsTotallyDisconnected {p}ᶜ

end PiBase

namespace PiBase.Formal

def P45 : Property where
  toPred := HasDispersionPoint
  well_defined φ h := sorry

end PiBase.Formal

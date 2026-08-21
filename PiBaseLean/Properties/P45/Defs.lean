module

public import Mathlib.Topology.Homeomorph.Lemmas

@[expose] public section

namespace PiBase

/- 45. Has a dispersion point -/
class HasDispersionPoint (X : Type*) [TopologicalSpace X] extends ConnectedSpace X where
  ex_dispersion_point : ∃ p : X, IsTotallyDisconnected {p}ᶜ

end PiBase

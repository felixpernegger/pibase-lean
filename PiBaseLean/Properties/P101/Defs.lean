import PiBaseLean.AdditionalDefs

open Topology Set Function Filter TopologicalSpace Topology.PiBase.AdditionalDefs

namespace PiBase

/- 101. Has closed retracts -/
class HasClosedRetract (X : Type*) [TopologicalSpace X] : Prop where
  has_closed_retract : ∀ A : Set X, IsRetract A → IsClosed A

end PiBase

namespace PiBase.Formal

abbrev P101 := HasClosedRetract

class NP101 (X : Type*) [TopologicalSpace X] where
  not_p101 : ¬ P101 X

end PiBase.Formal

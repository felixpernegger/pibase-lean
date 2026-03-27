import Mathlib
import PibaseLean.AdditionalDefs

open Topology Set Function Filter TopologicalSpace Topology.PiBase.AdditionalDefs

namespace PiBase

/- 101. Has closed retracts -/
class HasClosedRetract (X : Type*) [TopologicalSpace X] : Prop where
  has_closed_retract : ∀ A : Set X, IsRetractSet A → IsClosed A

end PiBase

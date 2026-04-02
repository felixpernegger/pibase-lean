import PibaseLean.AdditionalDefs

open Topology Set Function Filter TopologicalSpace Topology.PiBase.AdditionalDefs

namespace PiBase

/- 85. Basically disconnected -/
class BasicallyDisconnectedSpace (X : Type*) [TopologicalSpace X] : Prop where
  basically_disconnected : ∀ (U : Set X), IsCozero U → IsOpen (closure U)

end PiBase

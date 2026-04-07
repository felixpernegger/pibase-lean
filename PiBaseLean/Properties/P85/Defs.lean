module

public import PiBaseLean.AdditionalDefs
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace Topology.PiBase.AdditionalDefs

namespace PiBase

/- 85. Basically disconnected -/
class BasicallyDisconnectedSpace (X : Type*) [TopologicalSpace X] : Prop where
  basically_disconnected : ∀ (U : Set X), IsCozero U → IsOpen (closure U)

end PiBase

namespace PiBase.Formal

def P85 : Property where
  toPred := BasicallyDisconnectedSpace
  well_defined φ h := sorry

end PiBase.Formal

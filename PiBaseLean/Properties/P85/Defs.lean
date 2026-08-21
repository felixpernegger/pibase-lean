module

public import PiBaseLean.AdditionalDefs.Constructions

@[expose] public section

namespace PiBase

/- 85. Basically disconnected -/
class BasicallyDisconnectedSpace (X : Type*) [TopologicalSpace X] : Prop where
  basically_disconnected : ∀ (U : Set X), IsCozero U → IsOpen (closure U)

end PiBase

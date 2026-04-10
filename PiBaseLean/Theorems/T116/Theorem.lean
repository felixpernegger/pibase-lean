module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P179.Defs
public import PiBaseLean.Properties.P183.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

-- Most likely redundant
/-- Theorem T116: P179 (AlephZeroSpace) => P183 (HasCountableKNetwork) -/
theorem instHasCountableKNetworkOfAlephZeroSpace (X : Type u)
    [TopologicalSpace X] [AlephZeroSpace X] :
    HasCountableKNetwork X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T116 : P179 ≤ P183 := fun X _ ↦ @instHasCountableKNetworkOfAlephZeroSpace X _

end PiBase.Formal

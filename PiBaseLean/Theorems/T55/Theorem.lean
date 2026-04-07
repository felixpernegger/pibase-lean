module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P74.Defs

@[expose] public section

open Topology Set Function

namespace PiBase

/- Theorem 55: a Cosmic space has a countable network -/
theorem instCosmicSpaceOfHasCountableNetwork {X : Type*} [TopologicalSpace X] [CosmicSpace X] :
    HasCountableNetwork X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T55 : P74 ≤ P182 := @instCosmicSpaceOfHasCountableNetwork

end PiBase.Formal

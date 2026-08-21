module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P182.Bundled
public import PiBaseLean.Properties.P74.Bundled

@[expose] public section

namespace PiBase

/- Theorem 55: a Cosmic space has a countable network -/
theorem instCosmicSpaceOfHasCountableNetwork {X : Type*} [TopologicalSpace X] [CosmicSpace X] :
    HasCountableNetwork X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T55 : P74 ≤ P182 := @instCosmicSpaceOfHasCountableNetwork

end PiBase.Formal

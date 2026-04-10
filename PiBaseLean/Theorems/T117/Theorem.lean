module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P5.Defs
public import PiBaseLean.Properties.P179.Defs
public import PiBaseLean.Properties.P183.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T117: P183 (HasCountableKNetwork) + P5 (T3Space) => P179 (AlephZeroSpace) -/
theorem instAlephZeroSpaceOfHasCountableKNetworkOfT3Space (X : Type u)
    [TopologicalSpace X] [HasCountableKNetwork X] [T3Space X] :
    AlephZeroSpace X := by tauto

end PiBase

namespace PiBase.Formal

theorem T117 : P183 ⊓ P5 ≤ P179 := fun X _ ↦ and_imp.2 (@instAlephZeroSpaceOfHasCountableKNetworkOfT3Space X _)

end PiBase.Formal

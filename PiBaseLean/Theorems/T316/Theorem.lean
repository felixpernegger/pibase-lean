module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P42.Bundled
public import PiBaseLean.Properties.P90.Bundled

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T316: P90 (AlexandrovDiscrete) => P42 (LocallyPathConnectedSpace) -/
instance instLoallycPathConnectedSpaceOfAlexandrovDiscrete (X : Type u)
    [TopologicalSpace X] [h : AlexandrovDiscrete X] : LocallyPathConnectedSpace X :=
  AlexandrovDiscrete.locallyPathConnectedSpace

end PiBase

namespace PiBase.Formal

theorem T316 : P90 ≤ P42 := fun X _ ↦ @instLoallycPathConnectedSpaceOfAlexandrovDiscrete X _

end PiBase.Formal

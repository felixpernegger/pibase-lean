module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P42.Defs
public import PiBaseLean.Properties.P90.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T316: P90 (AlexandrovDiscrete) => P42 (LocPathConnectedSpace) -/
instance instLocPathConnectedSpaceOfAlexandrovDiscrete (X : Type u)
    [TopologicalSpace X] [h : AlexandrovDiscrete X] : LocPathConnectedSpace X :=
  AlexandrovDiscrete.locPathConnectedSpace

end PiBase

namespace PiBase.Formal

theorem T316 : P90 ≤ P42 := fun X _ ↦ @instLocPathConnectedSpaceOfAlexandrovDiscrete X _

end PiBase.Formal

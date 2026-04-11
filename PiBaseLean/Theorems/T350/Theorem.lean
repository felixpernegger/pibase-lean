module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P90.Defs
public import PiBaseLean.Properties.P147.Defs

@[expose] public section

universe u

open Topology Set Function Filter

namespace PiBase

/-- Theorem T350: P90 (AlexandrovDiscrete) => P147 (PSpace) -/
instance instPSpaceOfAlexandrovDiscrete (X : Type u)
    [TopologicalSpace X] [AlexandrovDiscrete X] :
    PSpace X where
  inter_open _ _ _ _ h := isOpen_iInter h

end PiBase

namespace PiBase.Formal

theorem T350 : P90 ≤ P147 := fun X _ ↦ @instPSpaceOfAlexandrovDiscrete X _

end PiBase.Formal

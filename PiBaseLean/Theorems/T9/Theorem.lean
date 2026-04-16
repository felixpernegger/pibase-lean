module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P16.Defs
public import PiBaseLean.Properties.P25.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T9: P16 (CompactSpace) => P25 (ExhaustibleByCompacts) -/
instance instExhaustibleByCompactsOfCompactSpace (X : Type u)
    [TopologicalSpace X] [CompactSpace X] :
    ExhaustibleByCompacts X where
  exhaustion := by
    apply Nonempty.intro
    exact CompactExhaustion.choice X

end PiBase

namespace PiBase.Formal

theorem T9 : P16 ≤ P25 := fun X _ ↦ @instExhaustibleByCompactsOfCompactSpace X _

end PiBase.Formal

module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P3.Defs
public import PiBaseLean.Properties.P16.Defs
public import PiBaseLean.Properties.P36.Defs
public import PiBaseLean.Properties.P188.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T480: P16 (CompactSpace) + P36 (PreconnectedSpace) +
P3 (T2Space) => P188 (ContinuumSpace) -/
theorem instContinuumSpaceOfCompactSpaceOfPreconnectedSpaceOfT2Space (X : Type u)
    [TopologicalSpace X] [CompactSpace X] [PreconnectedSpace X] [T2Space X] :
    ContinuumSpace X := by tauto

end PiBase

namespace PiBase.Formal

theorem T480 : P16 ⊓ P36 ⊓ P3 ≤ P188 := fun X _ ⟨⟨h1, h2⟩, h3⟩ ↦
  @instContinuumSpaceOfCompactSpaceOfPreconnectedSpaceOfT2Space X _ h1 h2 h3

end PiBase.Formal

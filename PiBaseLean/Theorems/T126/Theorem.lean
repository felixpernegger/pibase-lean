module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P3.Defs
public import PiBaseLean.Properties.P16.Defs
public import PiBaseLean.Properties.P49.Defs
public import PiBaseLean.Properties.P119.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T126: P16 (CompactSpace) + P3 (T2Space) +
P49 (ExtremallyDisconnected) => P119 (StoneanSpace) -/
theorem instStoneanSpaceOfCompactSpaceOfT2SpaceOfExtremallyDisconnected (X : Type u)
    [TopologicalSpace X] [CompactSpace X] [T2Space X] [ExtremallyDisconnected X] :
    StoneanSpace X := by tauto

end PiBase

namespace PiBase.Formal

theorem T126 : P16 ⊓ P3 ⊓ P49 ≤ P119 := fun X _ ⟨⟨h1, h2⟩, h3⟩ ↦
  @instStoneanSpaceOfCompactSpaceOfT2SpaceOfExtremallyDisconnected X _ h1 h2 h3

end PiBase.Formal

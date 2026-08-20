module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P3.Bundled
public import PiBaseLean.Properties.P16.Bundled
public import PiBaseLean.Properties.P47.Bundled
public import PiBaseLean.Properties.P195.Bundled

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T529: P16 (CompactSpace) + P3 (T2Space) +
P47 (TotallyDisconnectedSpace) => P195 (StoneSpace) -/
theorem instStoneSpaceOfCompactSpaceOfT2SpaceOfTotallyDisconnectedSpace (X : Type u)
    [TopologicalSpace X] [h : CompactSpace X] [h' : T2Space X] [h'' : TotallyDisconnectedSpace X] :
    StoneSpace X := by tauto

end PiBase

namespace PiBase.Formal

theorem T529 : P16 ⊓ P3 ⊓ P47 ≤ P195 := fun X _ ⟨⟨h1, h2⟩, h3⟩ ↦
  @instStoneSpaceOfCompactSpaceOfT2SpaceOfTotallyDisconnectedSpace X _ h1 h2 h3

end PiBase.Formal

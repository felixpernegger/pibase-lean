module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P37.Bundled
public import PiBaseLean.Properties.P37.Bundled
public import PiBaseLean.Properties.P200.Bundled
public import PiBaseLean.Properties.P200.Bundled

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T590: P200 (PreSimplyConnectedSpace) => P37 (PrePathConnectedSpace) -/
instance instPrepathConnectedSpaceOfPresimplyConnectedSpace (X : Type u)
    [TopologicalSpace X] [h : PresimplyConnectedSpace X] :
    PrepathConnectedSpace X := by
  by_cases! hX : IsEmpty X
  · apply PrepathConnectedSpace.mk
    intro x
    exfalso
    exact IsEmpty.false x
  have : SimplyConnectedSpace X := by
    exact instSimplyConnectedSpaceOfPresimplyConnectedSpaceOfNonempty X
  exact PathconnectedSpace.PrepathConnectedSpace X

end PiBase

namespace PiBase.Formal

theorem T590 : P200 ≤ P37 := fun X _ ↦ @instPrepathConnectedSpaceOfPresimplyConnectedSpace X _

end PiBase.Formal

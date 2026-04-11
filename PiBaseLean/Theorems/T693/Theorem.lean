module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P49.Defs
public import PiBaseLean.Properties.P85.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T693: P49 (ExtremallyDisconnected) => P85 (BasicallyDisconnectedSpace) -/
instance instBasicallyDisconnectedSpaceOfExtremallyDisconnected (X : Type u)
    [TopologicalSpace X] [h : ExtremallyDisconnected X] :
    BasicallyDisconnectedSpace X where
  basically_disconnected U hU := h.open_closure U hU.IsOpen

end PiBase

namespace PiBase.Formal

theorem T693 : P49 ≤ P85 := fun X _ ↦ @instBasicallyDisconnectedSpaceOfExtremallyDisconnected X _

end PiBase.Formal

module

public import PiBaseLean.Properties.P37.Defs
public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

namespace PiBase

open Topology Filter

variable (X : Type*) [TopologicalSpace X]

/-- A nonempty, prepathconnected space is connected. -/
instance instPathConnectedSpaceOfPrepathConnectedSpaceOfNonempty [h : PrepathConnectedSpace X]
    [h' : Nonempty X] : PathConnectedSpace X where
  nonempty := h'
  joined := h.joined

/-- A pathconnectespace is prepathconnected. -/
theorem PathconnectedSpace.PrepathConnectedSpace [h : PathConnectedSpace X] :
    PrepathConnectedSpace X where
  joined := h.joined
section Meta

theorem WellDefined.prepathConnectedSpace : WellDefined PrepathConnectedSpace :=
  sorry

end Meta

end PiBase

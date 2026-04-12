module

public import PiBaseLean.Properties.P37.Defs

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

end Meta

end PiBase

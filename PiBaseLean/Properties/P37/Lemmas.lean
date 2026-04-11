module

public import PiBaseLean.Properties.P37.Defs

@[expose] public section

namespace PiBase

open Topology Filter

variable {X : Type*} [TopologicalSpace X]

/-- A nonempty, prepathconnected space is connected. -/
instance PathConnectedSpaceOf

section Meta

end Meta

end PiBase

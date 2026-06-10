module

public import PiBaseLean.Properties.P242.Defs
public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

namespace PiBase

open Topology Filter Set

variable {X : Type*} [TopologicalSpace X]

section Meta

theorem WellDefined.weaklyContractibleSpace : WellDefined WeaklyContractibleSpace :=
  sorry

end Meta

end PiBase

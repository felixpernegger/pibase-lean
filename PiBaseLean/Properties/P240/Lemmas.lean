module

public import PiBaseLean.Properties.P240.Defs
public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

namespace PiBase

open Topology Filter Set

variable {X : Type*} [TopologicalSpace X]

section Meta

theorem WellDefined.isCWComplex : WellDefined IsCWComplex :=
  sorry

end Meta

end PiBase

module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P34.Defs

@[expose] public section

namespace PiBase

open TopologicalSpace

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.fullyNormalSpace : WellDefined FullyNormalSpace :=
  sorry

end Meta

end PiBase

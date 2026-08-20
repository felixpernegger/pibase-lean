module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P50.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.zeroDimensionalSpace : WellDefined ZeroDimensionalSpace :=
  fun {_ _} _ _ φ h => Formal.P50.well_defined φ.some h

end Meta

end PiBase

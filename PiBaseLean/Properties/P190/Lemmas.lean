module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P190.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta


variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.ordinalSpace : WellDefined OrdinalSpace :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    rcases h.homeo_ordinal with ⟨a, ha⟩
    exact ⟨a, IsHomeo.trans ⟨φ.symm⟩ ha⟩

end Meta

end PiBase

module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P152.Defs
public import PiBaseLean.Properties.P151.Bundled

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

open PiBase

section Meta


variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.markovRothbergerSpace : WellDefined MarkovRothbergerSpace :=
  fun {_ _} _ _ hXY h =>
    let φ := hXY.some
    ⟨fun hY ↦ (h.markov_rothberger ⟨φ.symm hY.some⟩).rothbergerGame_of_homeomorph φ⟩

end Meta

end PiBase

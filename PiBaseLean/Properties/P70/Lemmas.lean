module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P70.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta


variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.markovMengerSpace : WellDefined MarkovMengerSpace :=
  fun {_ _} _ _ hXY h =>
    let φ := hXY.some
    ⟨h.markov_menger.mengerGame_of_homeomorph φ⟩

end Meta

end PiBase

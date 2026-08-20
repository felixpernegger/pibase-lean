module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P161.Defs
public import PiBaseLean.Properties.P160.Bundled

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

open PiBase

section Meta


variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.markovKMengerSpace : WellDefined MarkovKMengerSpace :=
  fun {_ _} _ _ hXY h =>
    let φ := hXY.some
    ⟨h.markov_k_menger.kMengerGame_of_homeomorph φ⟩

end Meta

end PiBase

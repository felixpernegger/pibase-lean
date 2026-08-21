module

public import PiBaseLean.Properties.P160.Lemmas
public import PiBaseLean.Properties.P161.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.markovKMengerSpace : WellDefined MarkovKMengerSpace :=
  fun {_ _} _ _ hXY h =>
    let φ := hXY.some
    ⟨h.markov_k_menger.kMengerGame_of_homeomorph φ⟩

end PiBase

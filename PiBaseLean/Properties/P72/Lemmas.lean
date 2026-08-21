module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P72.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.twoMarkovMengerSpace : WellDefined TwoMarkovMengerSpace :=
  fun {_ _} _ _ hXY h =>
    let φ := hXY.some
    ⟨h.two_markov_menger.mengerGame_of_homeomorph φ⟩

end PiBase

module

public import PiBaseLean.Properties.P151.Lemmas
public import PiBaseLean.Properties.P152.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.markovRothbergerSpace : WellDefined MarkovRothbergerSpace :=
  fun {_ _} _ _ hXY h =>
    let φ := hXY.some
    ⟨fun hY ↦ (h.markov_rothberger ⟨φ.symm hY.some⟩).rothbergerGame_of_homeomorph φ⟩

end PiBase

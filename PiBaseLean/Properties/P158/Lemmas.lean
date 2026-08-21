module

public import PiBaseLean.Properties.P157.Lemmas
public import PiBaseLean.Properties.P158.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.markovKRothbergerSpace : WellDefined MarkovKRothbergerSpace :=
  fun {_ _} _ _ hXY h =>
    let φ := hXY.some
    ⟨h.markov_k_rothberger.kRothbergerGame_of_homeomorph φ⟩

end PiBase

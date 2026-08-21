module

public import PiBaseLean.Properties.P178.Defs

import PiBaseLean.Properties.P118.Lemmas

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.alephSpace : WellDefined AlephSpace :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    have : T3Space _ := φ.t3Space
    have : HasSigmaLocallyFiniteKNetwork _ :=
      WellDefined.hasSigmaLocallyFiniteKNetwork.homeo φ h.toHasSigmaLocallyFiniteKNetwork
    exact ⟨⟩

end PiBase

module

public import PiBaseLean.Properties.P177.Defs

import PiBaseLean.Properties.P117.Lemmas

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.sigmaSpace : WellDefined SigmaSpace :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    have : T3Space _ := φ.t3Space
    have : HasSigmaLocallyFiniteNetwork _ :=
      WellDefined.hasSigmaLocallyFiniteNetwork.homeo φ h.toHasSigmaLocallyFiniteNetwork
    exact ⟨⟩

end PiBase

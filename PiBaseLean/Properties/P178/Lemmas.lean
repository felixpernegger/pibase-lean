module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P178.Defs
public import PiBaseLean.Properties.P118.Bundled

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.alephSpace : WellDefined AlephSpace :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    have : T3Space _ := φ.t3Space
    have : HasSigmaLocallyFiniteKNetwork _ :=
      WellDefined.hasSigmaLocallyFiniteKNetwork.homeo φ h.toHasSigmaLocallyFiniteKNetwork
    exact ⟨⟩

end Meta

end PiBase

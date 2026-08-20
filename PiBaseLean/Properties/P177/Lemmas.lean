module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P177.Defs
public import PiBaseLean.Properties.P117.Bundled

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.sigmaSpace : WellDefined SigmaSpace :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    have : T3Space _ := φ.t3Space
    have : HasSigmaLocallyFiniteNetwork _ :=
      WellDefined.hasSigmaLocallyFiniteNetwork.homeo φ h.toHasSigmaLocallyFiniteNetwork
    exact ⟨⟩

end Meta

end PiBase

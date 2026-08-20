module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P179.Defs
public import PiBaseLean.Properties.P183.Bundled

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta


variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.alephZeroSpace : WellDefined AlephZeroSpace :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    -- Preserve both parent classes under homeomorphism
    -- This reuses the compiled P183 well-defined lemma
    have hT3 : T3Space _ := φ.t3Space
    have hK : HasCountableKNetwork _ :=
      WellDefined.hasCountableKNetwork.homeo φ h.toHasCountableKNetwork
    exact { hK with }

end Meta

end PiBase

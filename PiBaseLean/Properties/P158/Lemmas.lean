module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P158.Defs
public import PiBaseLean.Properties.P157.Bundled

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

open PiBase

section Meta


variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.markovKRothbergerSpace : WellDefined MarkovKRothbergerSpace :=
  fun {_ _} _ _ hXY h =>
    let φ := hXY.some
    ⟨h.markov_k_rothberger.kRothbergerGame_of_homeomorph φ⟩

end Meta

end PiBase

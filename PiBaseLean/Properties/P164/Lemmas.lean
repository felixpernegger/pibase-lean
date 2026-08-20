module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P164.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace
open Cardinal

section Meta

universe u

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.cardLtEveryMeasurableCardinal :
    WellDefined (fun (X : Type u) => CardLtEveryMeasurableCardinal X) :=
  fun {X Y} _ _ hXY h => by
    let φ := hXY.some
    constructor
    intro k hk
    -- transport #X / #Y by Cardinal.mk_congr φ.toEquiv, following P163/P114
    rw [← Cardinal.mk_congr φ.toEquiv]
    exact h.card_lt_every_measurable k hk

end Meta

end PiBase

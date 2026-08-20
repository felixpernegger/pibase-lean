module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P114.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta

universe u

theorem WellDefined.cardEqAlephOne : WellDefined (fun (X : Type u) => CardEqAlephOne X) :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    constructor
    rw [← Cardinal.mk_congr φ.toEquiv]
    exact h.card_eq

end Meta

end PiBase

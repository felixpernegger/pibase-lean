module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P106.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.hasGδDiagonal : WellDefined HasGδDiagonal :=
  fun {X Y} _ _ hXY h => by
    let φ := hXY.some
    constructor
    let Φ : Y × Y ≃ₜ X × X := φ.symm.prodCongr φ.symm
    convert IsGδ.preimage Φ.continuous h.has_g_delta_diagonal
    simp [Φ, diagonal]

end Meta

end PiBase

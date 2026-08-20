module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P108.Defs
public import PiBaseLean.Properties.P88.Bundled

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.hereditarilyCollectionwiseNormalSpace :
    WellDefined HereditarilyCollectionwiseNormalSpace :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    constructor
    intro s
    have hX := h.hereditarily_collectionwise_normal (φ ⁻¹' s)
    exact WellDefined.collectionwiseNormalSpace.homeo (IsHomeo.subset_preimage φ s).some hX

end Meta

end PiBase

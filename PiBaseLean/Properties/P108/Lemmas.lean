module

public import PiBaseLean.Properties.P108.Defs

import PiBaseLean.Properties.P88.Lemmas

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.hereditarilyCollectionwiseNormalSpace :
    WellDefined HereditarilyCollectionwiseNormalSpace :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    constructor
    intro s
    have hX := h.hereditarily_collectionwise_normal (φ ⁻¹' s)
    exact WellDefined.collectionwiseNormalSpace.homeo (IsHomeo.subset_preimage φ s).some hX

end PiBase

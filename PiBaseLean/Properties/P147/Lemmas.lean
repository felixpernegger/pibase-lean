module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P147.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.pSpace : WellDefined PSpace :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    constructor
    intro s hs
    have hg' : IsGδ (φ ⁻¹' s) := IsGδ.preimage φ.continuous hs
    have ho' := h.isGδ_open hg'
    exact φ.isOpen_preimage.mp ho'

end PiBase

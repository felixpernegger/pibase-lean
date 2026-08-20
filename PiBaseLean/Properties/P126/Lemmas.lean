module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P126.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta


variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.doorSpace : WellDefined DoorSpace :=
  fun {_ _} _ _ hXY h =>
    let φ := hXY.some
    ⟨fun s => by
        have hs := h.isOpen_or_isClosed (φ ⁻¹' s)
        rcases hs with ho | hc
        · left; exact φ.isOpen_preimage.mp ho
        · right; exact φ.isClosed_preimage.mp hc⟩

end Meta

end PiBase

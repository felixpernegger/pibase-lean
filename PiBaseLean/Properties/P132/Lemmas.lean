module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P132.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.gδSpace [h : GδSpace X] (f : X ≃ₜ Y) : GδSpace Y := by
  constructor
  intro s hs
  have h1 : IsClosed (f ⁻¹' s) := f.isClosed_preimage.mpr hs
  have h2 : IsGδ (f ⁻¹' s) := h.closed_gdelta h1
  convert IsGδ.preimage f.symm.continuous h2 using 1
  rw [← f.image_eq_preimage_symm]
  exact (f.image_preimage s).symm

theorem WellDefined.gδSpace : WellDefined GδSpace :=
  fun {_ _} _ _ h _ => Homeomorph.gδSpace h.some

end Meta

end PiBase

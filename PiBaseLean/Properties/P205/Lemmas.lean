module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P205.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.cutPointSpace [h : CutPointSpace X] (f : X ≃ₜ Y) : CutPointSpace Y where
  toConnectedSpace := (Homeomorph.connectedSpace_iff f).mp h.toConnectedSpace
  all_cut y := by simpa using PiBase.Homeomorph.isCutPoint f (h.all_cut (f.symm y))

theorem WellDefined.cutPointSpace : WellDefined CutPointSpace :=
  fun {_ _} _ _ h _ => Homeomorph.cutPointSpace h.some

end PiBase

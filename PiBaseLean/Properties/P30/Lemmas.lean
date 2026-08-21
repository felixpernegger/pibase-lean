module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P30.Defs

@[expose] public section

universe u v

namespace PiBase

variable {X : Type u} {Y : Type v} [t : TopologicalSpace X] [s : TopologicalSpace Y]

theorem WellDefined.paracompactSpace : WellDefined ParacompactSpace :=
  fun {_ _} _ _ h hX ↦ (Homeomorph.paracompactSpace_iff h.some).1 hX

end PiBase

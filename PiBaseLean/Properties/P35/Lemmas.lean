module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P35.Defs
public import PiBaseLean.Properties.P34.Bundled

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.fullyT4Space [FullyT4Space X] (f : X ≃ₜ Y) : FullyT4Space Y where
  toT1Space := f.t1Space
  toFullyNormalSpace :=
    @FullyNormalSpace.mk _ _ f.symm.isClosedEmbedding.paracompactSpace f.normalSpace

theorem WellDefined.fullyT4Space : WellDefined FullyT4Space :=
  fun {_ _} _ _ h _ => Homeomorph.fullyT4Space h.some

end Meta

end PiBase

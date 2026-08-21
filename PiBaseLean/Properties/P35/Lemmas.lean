module

public import PiBaseLean.Properties.P34.Lemmas
public import PiBaseLean.Properties.P35.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.fullyT4Space [FullyT4Space X] (f : X ≃ₜ Y) : FullyT4Space Y where
  toT1Space := f.t1Space
  toFullyNormalSpace :=
    @FullyNormalSpace.mk _ _ f.symm.isClosedEmbedding.paracompactSpace f.normalSpace

theorem WellDefined.fullyT4Space : WellDefined FullyT4Space :=
  fun {_ _} _ _ h _ => Homeomorph.fullyT4Space h.some

end PiBase

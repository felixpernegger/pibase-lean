module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P34.Defs

@[expose] public section

namespace PiBase

universe u v

variable {X : Type u} {Y : Type v} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.fullyNormalSpace : WellDefined FullyNormalSpace :=
  fun {_ _} _ _ φ _ =>
    @FullyNormalSpace.mk _ _ φ.some.symm.isClosedEmbedding.paracompactSpace φ.some.normalSpace

theorem Homeomorph.fullyNormalSpace [FullyNormalSpace X] (f : X ≃ₜ Y) : FullyNormalSpace Y :=
  @FullyNormalSpace.mk _ _ f.symm.isClosedEmbedding.paracompactSpace f.normalSpace

end PiBase

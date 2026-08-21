module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P103.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.stronglyKcSpace : WellDefined StronglyKcSpace :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    refine ⟨fun s Ks ↦ ?_⟩
    simpa only [Homeomorph.isClosed_image] using h.countablycompact_closed (φ.symm '' s)
      (Ks.image φ.symm.continuous)

end PiBase

module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P168.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.countableSetsDiscrete : WellDefined CountableSetsDiscrete :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    refine ⟨fun {s} hs => ?_⟩
    have hdisc : IsDiscrete (φ ⁻¹' s) :=
      h.countable_discrete (hs.preimage φ.injective)
    have h1 : IsDiscrete (φ '' (φ ⁻¹' s)) := hdisc.image φ.isInducing
    rwa [φ.image_preimage] at h1

end PiBase

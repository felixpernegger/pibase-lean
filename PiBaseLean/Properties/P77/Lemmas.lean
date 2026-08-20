module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P77.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta


variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.corsonCompactSpace : WellDefined CorsonCompactSpace :=
  fun {X _} _ _ hXY h => by
    let φ := hXY.some
    obtain ⟨α, f, hf⟩ := h.isHomoeo_subset
    -- preserve compact via φ.compactSpace: need CompactSpace X instance from h
    exact {
      toCompactSpace := @Homeomorph.compactSpace _ _ _ _ h.toCompactSpace φ
      isHomoeo_subset := ⟨α, f ∘ φ.symm, hf.comp φ.symm.isEmbedding⟩
    }

end Meta

end PiBase

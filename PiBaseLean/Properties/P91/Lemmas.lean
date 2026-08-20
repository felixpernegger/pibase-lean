module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P91.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta


variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.eberleinCompactSpace : WellDefined EberleinCompactSpace :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    obtain ⟨E, hNAG, hNS, f, hComp, hEmb⟩ := h.eberlein_compact
    exact {
      toCompactSpace := @Homeomorph.compactSpace _ _ _ _ h.toCompactSpace φ
      eberlein_compact := ⟨E, hNAG, hNS, f ∘ φ.symm, hComp, hEmb.comp φ.symm.isEmbedding⟩
    }

end Meta

end PiBase

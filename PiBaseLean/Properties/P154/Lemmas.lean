module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P154.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace


section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.goSpace : WellDefined GoSpace :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    obtain ⟨Z, f, tZ, hLots, hEmb⟩ := h.subset_lots
    refine ⟨⟨Z, f ∘ φ.symm, tZ, hLots, ?_⟩⟩
    exact hEmb.comp φ.symm.isEmbedding

end Meta

end PiBase

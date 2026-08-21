module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P186.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.embedsInTopologicalWGroupSpace : WellDefined EmbedsInTopologicalWGroupSpace :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    obtain ⟨Z, tZ, f, hW, hG, hEmb⟩ := h.embeds_in_topological_w_group
    exact ⟨Z, tZ, f ∘ φ.symm, hW, hG, hEmb.comp φ.symm.isEmbedding⟩

end PiBase

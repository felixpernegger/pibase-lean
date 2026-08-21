module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P97.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.embeddableInR : WellDefined EmbeddableInR :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    obtain ⟨f, hf⟩ := h.embeddable
    exact ⟨⟨f ∘ φ.symm, hf.comp φ.symm.isEmbedding⟩⟩

end PiBase

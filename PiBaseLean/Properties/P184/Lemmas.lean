module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P184.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.embeddableInEuclideanSpace : WellDefined EmbeddableInEuclideanSpace :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    rcases h.embeddable with ⟨n, f, hf⟩
    exact ⟨n, f ∘ φ.symm, hf.comp φ.symm.isEmbedding⟩

end PiBase

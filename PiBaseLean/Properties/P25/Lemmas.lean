module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P25.Defs

@[expose] public section

namespace PiBase

open Set

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.exhaustibleByCompacts : WellDefined ExhaustibleByCompacts :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    obtain ⟨K⟩ := h.exhaustion
    refine ⟨⟨⟨fun n => φ '' K n, fun n => (K.isCompact' n).image φ.continuous, fun n => ?_, ?_⟩⟩⟩
    · -- monotonicity via image_mono and φ.continuous / φ.image_interior
      have h1 : φ '' K n ⊆ φ '' interior (K (n + 1)) :=
        Set.image_mono (K.subset_interior_succ n)
      rw [φ.image_interior] at h1
      exact h1
    · -- union univ via image_iUnion and image_univ/surjective
      calc (⋃ n, φ '' K n : Set _) = φ '' (⋃ n, K n) := by
            rw [← Set.image_iUnion]
        _ = φ '' univ := by rw [K.iUnion_eq]
        _ = univ := Set.image_univ_of_surjective φ.surjective

end PiBase

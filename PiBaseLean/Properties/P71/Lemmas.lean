module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P71.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta


variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.sigmaRelativelyCompactSpace : WellDefined SigmaRelativelyCompactSpace :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    obtain ⟨R, h_eq, hRC⟩ := h.sigma_relatively_compact
    refine ⟨⟨fun n => φ '' R n, ?_, fun n => ?_⟩⟩
    · -- union univ via image_iUnion and image_univ/surjective
      calc (⋃ n, φ '' R n : Set _) = φ '' (⋃ n, R n) := by rw [← Set.image_iUnion]
        _ = φ '' univ := by rw [h_eq]
        _ = univ := Set.image_univ_of_surjective φ.surjective
    · have hRn : IsRelativelyCompact (R n) := hRC n
      -- preserve relative compactness: map open cover through homeomorphism preimage
      intro ι U hU_open hU_cover
      have hV_open : ∀ i, IsOpen (φ ⁻¹' U i) := fun i => (hU_open i).preimage φ.continuous
      have hV_cover : (⋃ i, φ ⁻¹' U i : Set _) = univ := by
        calc (⋃ i, φ ⁻¹' U i : Set _) = φ ⁻¹' (⋃ i, U i) := by rw [Set.preimage_iUnion]
          _ = φ ⁻¹' univ := by rw [hU_cover]
          _ = univ := Set.preimage_univ
      obtain ⟨t, ht⟩ := hRn _ hV_open hV_cover
      refine ⟨t, ?_⟩
      intro y hy
      obtain ⟨x, hx, rfl⟩ := hy
      have hx' : x ∈ ⋃ i ∈ t, φ ⁻¹' U i := ht hx
      simp only [Set.mem_iUnion] at hx'
      obtain ⟨i, hi, hxi⟩ := hx'
      exact Set.mem_iUnion.mpr ⟨i, Set.mem_iUnion.mpr ⟨hi, hxi⟩⟩

end Meta

end PiBase

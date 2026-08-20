module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P110.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.developableSpace : WellDefined DevelopableSpace :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    obtain ⟨⟨idx, toCover, isOpen, isCover, isLocalBase⟩⟩ := h.developable
    refine ⟨⟨⟨idx, fun {n} t => φ '' toCover t, fun n t => φ.isOpenMap _ (isOpen n t), ?_, ?_⟩⟩⟩
    · intro n
      calc (⋃ t : idx n, φ '' toCover t) = φ '' (⋃ t, toCover t) := by
            rw [image_iUnion]
        _ = φ '' univ := by rw [isCover n]
        _ = univ := by rw [image_univ, EquivLike.range_eq_univ]
    · intro y
      have hx :
          (𝓝 (φ.symm y)).HasBasis
            (fun _ => True) (fun n => CoverStar (toCover (n := n)) (φ.symm y)) :=
        isLocalBase (φ.symm y)
      have hEq : Filter.map φ (𝓝 (φ.symm y)) = 𝓝 y := by
        calc Filter.map φ (𝓝 (φ.symm y)) = 𝓝 (φ (φ.symm y)) := φ.map_nhds_eq (φ.symm y)
          _ = 𝓝 y := by rw [φ.apply_symm_apply]
      have hBasisY :
          (𝓝 y).HasBasis
            (fun _ => True) (fun n => φ '' CoverStar (toCover (n := n)) (φ.symm y)) := by
        rw [← hEq]
        exact hx.map φ
      have hStarEq : ∀ n, φ '' CoverStar (toCover (n := n)) (φ.symm y) =
          CoverStar (fun t : idx n => φ '' toCover t) y := by
        intro n
        ext y'
        simp only [CoverStar, mem_iUnion, mem_image]
        constructor
        · rintro ⟨x, ⟨i, hi_mem, hx_mem⟩, rfl⟩
          refine ⟨i, ⟨⟨φ.symm y, hi_mem, φ.apply_symm_apply y⟩, ?_⟩⟩
          exact ⟨x, hx_mem, rfl⟩
        · rintro ⟨i, ⟨⟨z, hz_mem, rfl⟩, hy_mem⟩⟩
          obtain ⟨x, hx_mem, rfl⟩ := hy_mem
          exact ⟨x, ⟨i, by simpa using hz_mem, hx_mem⟩, rfl⟩
      simp_rw [hStarEq] at hBasisY
      exact hBasisY

end Meta

end PiBase

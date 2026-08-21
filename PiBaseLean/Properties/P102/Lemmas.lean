module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P102.Defs

@[expose] public section

namespace PiBase

open Topology

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.semimetrizableSpace : WellDefined SemimetrizableSpace :=
  fun {X Y} _ _ hXY h => by
    let φ := hXY.some
    obtain ⟨symX⟩ := h.nonempty_semimetric
    let : Symmetric X := symX.toSymmetric
    let f : Y → X := φ.symm
    let distY : Y → Y → ℝ := fun y₁ y₂ => dist (f y₁) (f y₂)
    let symYCore : Symmetric Y :=
      { dist := distY
        dist_nonneg := fun y₁ y₂ => Symmetric.dist_nonneg (f y₁) (f y₂)
        dist_self := fun y => Symmetric.dist_self (f y)
        dist_comm := fun y₁ y₂ => Symmetric.dist_comm (f y₁) (f y₂)
        eq_of_dist_eq_zero := fun {y₁ y₂} h0 =>
          φ.symm.injective (Symmetric.eq_of_dist_eq_zero h0) }
    refine ⟨⟨{ symYCore with symmetric_nbhd := fun y => ?_ }⟩⟩
    have hX := symX.symmetric_nbhd (f y)
    have hEq : Filter.map φ (𝓝 (f y)) = 𝓝 y := by
      have hmap := φ.map_nhds_eq (f y)
      have : φ (f y) = y := φ.apply_symm_apply y
      rw [this] at hmap
      exact hmap
    have hMap : (𝓝 y).HasBasis (fun ε => 0 < ε) (fun ε => φ '' Symmetric.ball (f y) ε) := by
      rw [← hEq]
      exact hX.map φ
    have hBallEq : ∀ ε, φ '' Symmetric.ball (f y) ε = Symmetric.ball y ε := by
      intro ε
      ext y'
      simp only [Symmetric.ball, Set.mem_image, Set.mem_ofPred_eq]
      constructor
      · rintro ⟨x, hx, rfl⟩
        change dist (f (φ x)) (f y) ≤ ε
        simpa [f, Homeomorph.symm_apply_apply] using hx
      · intro hy
        exact ⟨f y', hy, φ.apply_symm_apply y'⟩
    simp_rw [hBallEq] at hMap
    exact hMap

end PiBase

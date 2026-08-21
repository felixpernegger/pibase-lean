module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P45.Defs

@[expose] public section

namespace PiBase

open Set

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.hasDispersionPoint : WellDefined HasDispersionPoint :=
  fun {X Y} _ _ hφ hX => by
    let φ := hφ.some
    have hcX : ConnectedSpace X := hX.toConnectedSpace
    have hcY : ConnectedSpace Y := (Homeomorph.connectedSpace_iff φ).mp hcX
    obtain ⟨p, hp⟩ := hX.ex_dispersion_point
    refine ⟨φ p, ?_⟩
    have h_eq : φ '' {p}ᶜ = {φ p}ᶜ := by
      ext y
      constructor
      · rintro ⟨x, hx, rfl⟩
        simp only [mem_compl_iff, mem_singleton_iff] at hx ⊢
        intro heq
        apply hx
        exact φ.injective heq
      · intro hy
        simp only [mem_compl_iff, mem_singleton_iff] at hy ⊢
        refine ⟨φ.symm y, ?_, φ.apply_symm_apply y⟩
        simp only [mem_compl_iff, mem_singleton_iff]
        intro heq
        apply hy
        calc y = φ (φ.symm y) := (φ.apply_symm_apply y).symm
          _ = φ p := by rw [heq]
    rw [← h_eq]
    exact φ.isEmbedding.isTotallyDisconnected_image.mpr hp

end PiBase

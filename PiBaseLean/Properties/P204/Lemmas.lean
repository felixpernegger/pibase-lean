module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P204.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.hasACutPoint : WellDefined HasACutPoint :=
  fun {X Y} _ _ hφ hX => by
    let φ := hφ.some
    have hcX : ConnectedSpace X := hX.toConnectedSpace
    have hcY : ConnectedSpace Y := (Homeomorph.connectedSpace_iff φ).mp hcX
    obtain ⟨p, hp⟩ := hX.ex_cut
    refine ⟨φ p, ?_⟩
    intro hpc
    have h_eq : φ.symm '' ({φ p}ᶜ : Set Y) = ({p}ᶜ : Set X) := by
      ext x
      constructor
      · rintro ⟨y, hy, rfl⟩
        simp only [mem_compl_iff, mem_singleton_iff] at hy ⊢
        intro heq
        apply hy
        rw [← φ.apply_symm_apply (y := y), heq]
      · intro hx
        simp only [mem_compl_iff, mem_singleton_iff] at hx
        refine ⟨φ x, ?_, by simp [Homeomorph.symm_apply_apply]⟩
        simp only [mem_compl_iff, mem_singleton_iff]
        intro heq
        apply hx
        have : φ.symm (φ x) = φ.symm (φ p) := by rw [heq]
        simpa [Homeomorph.symm_apply_apply] using this
    have : IsPreconnected ({p}ᶜ : Set X) := by
      rw [← h_eq]
      exact hpc.image _ φ.symm.continuous.continuousOn
    exact hp this

end Meta

end PiBase

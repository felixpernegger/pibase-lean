module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P182.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.hasCountableNetwork [HasCountableNetwork X] (f : X ≃ₜ Y) :
    HasCountableNetwork Y := by
  rcases (inferInstance : HasCountableNetwork X) with ⟨ι, g, hι_cnt, hg⟩
  refine ⟨ι, fun i => f '' g i, hι_cnt, ?_⟩
  intro y s hs
  have h_mem_comap : f ⁻¹' s ∈ comap f (𝓝 y) := by
    rw [Filter.mem_comap]
    exact ⟨s, hs, Subset.rfl⟩
  have h_comap_eq : comap f (𝓝 y) = 𝓝 (f.symm y) := f.comap_nhds_eq y
  have h_pre : f ⁻¹' s ∈ 𝓝 (f.symm y) := h_comap_eq ▸ h_mem_comap
  obtain ⟨i, hi_mem, hi_sub⟩ := hg (f.symm y) (f ⁻¹' s) h_pre
  refine ⟨i, ?_, ?_⟩
  · exact ⟨f.symm y, hi_mem, f.apply_symm_apply y⟩
  · intro z hz
    rcases hz with ⟨w, hw_mem, rfl⟩
    have hw_in : w ∈ f ⁻¹' s := hi_sub hw_mem
    exact hw_in

theorem WellDefined.hasCountableNetwork : WellDefined HasCountableNetwork :=
  fun {_ _} _ _ h _ ↦ Homeomorph.hasCountableNetwork h.some

end PiBase

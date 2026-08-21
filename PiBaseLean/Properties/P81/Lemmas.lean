module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P81.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.countablyTightSpace [CountablyTightSpace X] (f : X ≃ₜ Y) :
    CountablyTightSpace Y := by
  constructor
  intro y A hy
  have h_mem_pre : f.symm y ∈ f ⁻¹' closure A := by
    rw [Set.mem_preimage, f.apply_symm_apply]
    exact hy
  have h_eq : f ⁻¹' closure A = closure (f ⁻¹' A) := f.preimage_closure A
  have h_mem : f.symm y ∈ closure (f ⁻¹' A) := h_eq ▸ h_mem_pre
  obtain ⟨D, hD_cnt, hD_sub, hD_cl⟩ :=
    (inferInstance : CountablyTightSpace X).countably_tight (f.symm y) (f ⁻¹' A) h_mem
  refine ⟨f '' D, hD_cnt.image _, ?_, ?_⟩
  · intro z hz
    rcases hz with ⟨x, hxD, rfl⟩
    have : x ∈ f ⁻¹' A := hD_sub hxD
    rwa [Set.mem_preimage] at this
  · have h_img : f '' closure D = closure (f '' D) := f.image_closure D
    have h_y : y ∈ f '' closure D := ⟨f.symm y, hD_cl, f.apply_symm_apply y⟩
    rwa [h_img] at h_y

theorem WellDefined.countablyTightSpace : WellDefined CountablyTightSpace :=
  fun {_ _} _ _ h _ ↦ Homeomorph.countablyTightSpace h.some

end PiBase

module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P162.Defs

@[expose] public section

universe u v

namespace PiBase

variable {X : Type u} {Y : Type v} [t : TopologicalSpace X] [s : TopologicalSpace Y]

/- Most likely true but difficult - proof omitted -/

/-
theorem Homeomorph.realcompactSpace [h : RealcompactSpace X] (g : X ≃ₜ Y) : RealcompactSpace Y := by
  rw [realcompactSpace_iff_fun_self] at h ⊢
  obtain ⟨s, sc, hs⟩ := h
  have f : (X → ℝ) ≃ₜ (Y → ℝ) := .piCongr g.toEquiv (fun _ ↦ .refl ℝ)
  exact ⟨f '' s, f.isClosed_image.mpr sc, isHomeo <| (g.symm.trans hs.some).trans <| f.image s⟩
-/

theorem WellDefined.realcompactSpace : WellDefined RealcompactSpace :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    obtain ⟨ι, f, hf⟩ := h.homeo_closed
    exact ⟨⟨ι, f ∘ φ.symm, hf.comp φ.symm.isClosedEmbedding⟩⟩

end PiBase

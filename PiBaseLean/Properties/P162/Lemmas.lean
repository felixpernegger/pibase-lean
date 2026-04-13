module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P162.Defs
public import Mathlib.Topology.Connected.PathConnected

@[expose] public section

universe u v

namespace PiBase

open Topology Filter Set TopologicalSpace

variable {X : Type u} {Y : Type v} [t : TopologicalSpace X] [s : TopologicalSpace Y]

/- Most likely true but difficult
theorem realcompactSpace_iff_fun_self (X : Type u) [TopologicalSpace X] :
    RealcompactSpace X ↔ ∃ s : Set (X → ℝ), IsClosed s ∧ IsHomeo X s := by
  refine ⟨fun ⟨ι, s, sc, hs⟩ ↦ ?_, fun ⟨s, sc, hs⟩ ↦ ⟨X, s, sc, hs⟩⟩

  let s' : Set (s → ℝ) := by
    sorry
  replace g := hs.some
  let sup : Set ι := {i | ∃ r ∈ s, ∃ t ∈ s, r i ≠ t i}
  let h : sup → s := by

    sorry
  sorry
-/

section Meta

/-
theorem Homeomorph.realcompactSpace [h : RealcompactSpace X] (g : X ≃ₜ Y) : RealcompactSpace Y := by
  rw [realcompactSpace_iff_fun_self] at h ⊢
  obtain ⟨s, sc, hs⟩ := h
  have f : (X → ℝ) ≃ₜ (Y → ℝ) := .piCongr g.toEquiv (fun _ ↦ .refl ℝ)
  exact ⟨f '' s, f.isClosed_image.mpr sc, isHomeo <| (g.symm.trans hs.some).trans <| f.image s⟩
-/

theorem WellDefined.realcompactSpace : WellDefined RealcompactSpace :=
  fun {_ _} _ _ XY h ↦
  let ⟨ι, s, sc, sh⟩ := h.homeo_closed
  { homeo_closed := ⟨ι, s, sc, XY.symm.trans sh⟩}

end Meta

end PiBase

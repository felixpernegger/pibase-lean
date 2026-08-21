module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P203.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.almostDiscreteSpace : WellDefined AlmostDiscreteSpace :=
  fun {X Y} _ _ φ h => by
    obtain ⟨p, hp⟩ := h.ex_point
    refine ⟨⟨φ.some p, fun x => ?_⟩⟩
    have h_ne_iff : x ≠ φ.some p ↔ φ.some.symm x ≠ p := by
      constructor
      · intro h_ne h_eq
        apply h_ne
        calc x = φ.some (φ.some.symm x) := (φ.some.apply_symm_apply x).symm
          _ = φ.some p := by rw [h_eq]
      · intro h_ne h_eq
        apply h_ne
        calc φ.some.symm x = φ.some.symm (φ.some p) := by rw [h_eq]
          _ = p := φ.some.symm_apply_apply p
    have h_singleton_eq : φ.some.symm '' {x} = {φ.some.symm x} := Set.image_singleton
    have h_isOpen_iff : IsOpen {φ.some.symm x} ↔ IsOpen {x} := by
      have h_img := φ.some.symm.isOpen_image (s := {x})
      rw [h_singleton_eq] at h_img
      exact h_img
    calc x ≠ φ.some p ↔ φ.some.symm x ≠ p := h_ne_iff
      _ ↔ IsOpen {φ.some.symm x} := hp (φ.some.symm x)
      _ ↔ IsOpen {x} := h_isOpen_iff

theorem Homeomorph.almostDiscreteSpace [AlmostDiscreteSpace X]
    (f : X ≃ₜ Y) : AlmostDiscreteSpace Y := by
  obtain ⟨p, hp⟩ := ‹AlmostDiscreteSpace X›.ex_point
  refine ⟨⟨f p, fun x => ?_⟩⟩
  have h_ne_iff : x ≠ f p ↔ f.symm x ≠ p := by
    constructor
    · intro h_ne h_eq
      apply h_ne
      calc x = f (f.symm x) := (f.apply_symm_apply x).symm
        _ = f p := by rw [h_eq]
    · intro h_ne h_eq
      apply h_ne
      calc f.symm x = f.symm (f p) := by rw [h_eq]
        _ = p := f.symm_apply_apply p
  have h_singleton_eq : f.symm '' {x} = {f.symm x} := Set.image_singleton
  have h_isOpen_iff : IsOpen {f.symm x} ↔ IsOpen {x} := by
    have h_img := f.symm.isOpen_image (s := {x})
    rw [h_singleton_eq] at h_img
    exact h_img
  calc x ≠ f p ↔ f.symm x ≠ p := h_ne_iff
    _ ↔ IsOpen {f.symm x} := hp (f.symm x)
    _ ↔ IsOpen {x} := h_isOpen_iff

end PiBase

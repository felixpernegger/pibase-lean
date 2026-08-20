module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P85.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta


variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.basicallyDisconnectedSpace : WellDefined BasicallyDisconnectedSpace :=
  fun {X Y} _ _ hXY h => by
    let φ := hXY.some
    constructor
    intro U hU
    have h_pre_cozero : IsCozero (φ ⁻¹' U) := by
      obtain ⟨f, hf⟩ := hU
      let φc : C(X, Y) := ⟨φ, φ.continuous⟩
      refine ⟨f.comp φc, ?_⟩
      have : (f.comp φc : C(X, ℝ)).toFun ⁻¹' ({0}ᶜ : Set ℝ) =
          φ ⁻¹' (f.toFun ⁻¹' {0}ᶜ) := by
        ext x; simp [φc]
      rw [this, hf]
    have h_open_closure_pre : IsOpen (closure (φ ⁻¹' U)) :=
      h.basically_disconnected _ h_pre_cozero
    have h_eq : closure (φ ⁻¹' U) = φ ⁻¹' closure U :=
      (φ.preimage_closure U).symm
    have h_open_preimage : IsOpen (φ ⁻¹' closure U) := h_eq ▸ h_open_closure_pre
    exact (φ.isOpen_preimage).mp h_open_preimage

end Meta

end PiBase

module

public import PiBaseLean.AdditionalDefs.Constructions
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 85. Basically disconnected -/
class BasicallyDisconnectedSpace (X : Type*) [TopologicalSpace X] : Prop where
  basically_disconnected : ∀ (U : Set X), IsCozero U → IsOpen (closure U)

end PiBase

namespace PiBase.Formal

def P85 : Property where
  toPred := BasicallyDisconnectedSpace
  well_defined {X Y} _ _ φ h := by
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

end PiBase.Formal

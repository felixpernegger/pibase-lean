module

public import Mathlib.Topology.Connected.Basic
public import Mathlib.Topology.Connected.TotallyDisconnected
public import Mathlib.Topology.Homeomorph.Lemmas
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 45. Has a dispersion point -/
class HasDispersionPoint (X : Type*) [TopologicalSpace X] extends ConnectedSpace X where
  ex_dispersion_point : ∃ p : X, IsTotallyDisconnected {p}ᶜ

end PiBase

namespace PiBase.Formal

def P45 : Property where
  toPred := HasDispersionPoint
  well_defined {X Y} _ _ φ h := by
    have hcX : ConnectedSpace X := h.toConnectedSpace
    have hcY : ConnectedSpace Y := (Homeomorph.connectedSpace_iff φ).mp hcX
    obtain ⟨p, hp⟩ := h.ex_dispersion_point
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

end PiBase.Formal

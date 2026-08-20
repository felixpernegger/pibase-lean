module

public import PiBaseLean.AdditionalDefs.Constructions
public import PiBaseLean.Properties.Bundled.Defs
public import Mathlib.Topology.Connected.Basic
public import Mathlib.Topology.Homeomorph.Lemmas

@[expose] public section

open Topology Set Function

namespace PiBase

/- 204. Has a cut point -/
class HasACutPoint (X : Type*)
    [TopologicalSpace X] extends ConnectedSpace X where
  ex_cut : ∃ p : X, IsCutPoint p

end PiBase

namespace PiBase.Formal

def P204 : Property where
  toPred := HasACutPoint
  well_defined {X Y} _ _ φ h := by
    have hcX : ConnectedSpace X := h.toConnectedSpace
    have hcY : ConnectedSpace Y := (Homeomorph.connectedSpace_iff φ).mp hcX
    obtain ⟨p, hp⟩ := h.ex_cut
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

end PiBase.Formal

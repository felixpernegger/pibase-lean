module

public import Mathlib.Data.Set.Countable
public import Mathlib.Topology.Separation.SeparatedNhds
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Filter TopologicalSpace

universe u

namespace PiBase

/- 165. Pseudonormal -/
class PseudonormalSpace (X : Type u) [TopologicalSpace X] : Prop where
  pseudonormal (s t : Set X) :
    s.Countable → IsClosed s → IsClosed t → Disjoint s t → SeparatedNhds s t

end PiBase

namespace PiBase.Formal

def P165 : Property where
  toPred := PseudonormalSpace
  well_defined φ h := by
    constructor
    intro s t hsCount hsClosed htClosed hsDisj
    have hsc : (φ ⁻¹' s).Countable := by
      have : φ ⁻¹' s = φ.symm '' s := by
        ext x; constructor
        · intro hx; exact ⟨φ x, hx, by simp⟩
        · rintro ⟨y, hy, rfl⟩; simp [hy]
      rw [this]; exact hsCount.image φ.symm
    have hClosed_s : IsClosed (φ ⁻¹' s) := φ.isClosed_preimage.mpr hsClosed
    have hClosed_t : IsClosed (φ ⁻¹' t) := φ.isClosed_preimage.mpr htClosed
    have hDisj : Disjoint (φ ⁻¹' s) (φ ⁻¹' t) := by
      rw [Set.disjoint_left] at hsDisj ⊢; intro x a b; exact hsDisj a b
    obtain ⟨U, V, hUo, hVo, hsU, htV, hUV⟩ :=
      h.pseudonormal _ _ hsc hClosed_s hClosed_t hDisj
    refine ⟨φ '' U, φ '' V, φ.isOpen_image.mpr hUo, φ.isOpen_image.mpr hVo, ?_, ?_, ?_⟩
    · intro y hy
      have : φ.symm y ∈ φ ⁻¹' s := by change φ (φ.symm y) ∈ s; simpa using hy
      exact ⟨φ.symm y, hsU this, by simp⟩
    · intro y hy
      have : φ.symm y ∈ φ ⁻¹' t := by change φ (φ.symm y) ∈ t; simpa using hy
      exact ⟨φ.symm y, htV this, by simp⟩
    · rw [Set.disjoint_left]
      rintro y ⟨x₁, hx₁, hxy₁⟩ ⟨x₂, hx₂, hxy₂⟩
      have hx : x₁ = x₂ := φ.injective (hxy₁.trans hxy₂.symm)
      exact Set.disjoint_left.mp hUV hx₁ (hx ▸ hx₂)

end PiBase.Formal

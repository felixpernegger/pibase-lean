module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P165.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.pseudonormalSpace : WellDefined PseudonormalSpace :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
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

end PiBase

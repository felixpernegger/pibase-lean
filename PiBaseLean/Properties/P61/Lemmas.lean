module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P61.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta


variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.cozeroComplementedSpace : WellDefined CozeroComplementedSpace :=
  fun {X Y} _ _ hXY h => by
    let φ := hXY.some
    constructor
    intro s hs
    -- s : Set Y cozero in Y, pull back to X via φ⁻¹'
    have h_s_pre_cozero : IsCozero (φ ⁻¹' s) := by
      obtain ⟨f, hf⟩ := hs
      -- transport f : C(Y,ℝ) to C(X,ℝ) by composing with homeomorphism φ : C(X,Y)
      let φc : C(X, Y) := ⟨φ, φ.continuous⟩
      refine ⟨f.comp φc, ?_⟩
      have h_eq : (f.comp φc : C(X, ℝ)).toFun ⁻¹' ({0}ᶜ : Set ℝ) =
          φ ⁻¹' (f.toFun ⁻¹' {0}ᶜ) := by
        ext x; simp [φc]
      rw [h_eq, hf]
    obtain ⟨tX, htX_cozero, htX_disj, htX_dense⟩ :=
      h.cozero_complemented (φ ⁻¹' s) h_s_pre_cozero
    -- push forward tX to Y via image (equivalent to preimage via φ.symm)
    let tY : Set Y := φ '' tX
    have htY_cozero : IsCozero tY := by
      obtain ⟨g, hg⟩ := htX_cozero
      let ψc : C(Y, X) := ⟨φ.symm, φ.symm.continuous⟩
      refine ⟨g.comp ψc, ?_⟩
      have h_eq1 : (g.comp ψc : C(Y, ℝ)).toFun ⁻¹' ({0}ᶜ : Set ℝ) =
          ψc.toFun ⁻¹' (g.toFun ⁻¹' {0}ᶜ) := by
        ext y; simp [ψc]
      rw [h_eq1, hg]
      ext y
      constructor
      · intro hy
        change φ.symm y ∈ tX at hy
        exact ⟨φ.symm y, hy, by simp⟩
      · rintro ⟨x, hx, rfl⟩; simp [ψc, hx]
    refine ⟨tY, htY_cozero, ?_, ?_⟩
    · -- Disjoint via pullback equivalence
      rw [Set.disjoint_left]
      intro y hyS hyT
      obtain ⟨x, hxT, rfl⟩ := hyT
      exact Set.disjoint_left.mp htX_disj hyS hxT
    · -- φ⁻¹'(s ∪ φ''tX) = (φ⁻¹'s) ∪ tX
      have h_pre_union : φ ⁻¹' (s ∪ tY) = (φ ⁻¹' s) ∪ tX := by
        ext x
        constructor
        · intro hx
          rcases hx with hs' | ht'
          · exact Or.inl hs'
          · have : φ x ∈ tY := ht'
            rcases this with ⟨z, hz, hz_eq⟩
            exact Or.inr (φ.injective hz_eq ▸ hz)
        · intro hx
          rcases hx with h1 | h2
          · exact Set.mem_preimage.mpr (Set.mem_union_left _ h1)
          · exact Set.mem_preimage.mpr (Set.mem_union_right _ ⟨x, h2, rfl⟩)
      have h_dense_pre : Dense (φ ⁻¹' (s ∪ tY)) := by rw [h_pre_union]; exact htX_dense
      have h_closure_eq : φ ⁻¹' closure (s ∪ tY) = closure (φ ⁻¹' (s ∪ tY)) :=
        φ.preimage_closure (s ∪ tY)
      have h_univ : closure (φ ⁻¹' (s ∪ tY)) = univ := h_dense_pre.closure_eq
      have h_pre_closure_univ : φ ⁻¹' closure (s ∪ tY) = univ := by
        rw [h_closure_eq, h_univ]
      have h_closure_univ : closure (s ∪ tY) = univ := by
        have h_inj_pre : Injective (Set.preimage φ) :=
          (Set.preimage_injective).mpr φ.surjective
        have : Set.preimage φ (closure (s ∪ tY)) = Set.preimage φ (univ : Set Y) := by
          rw [h_pre_closure_univ, Set.preimage_univ]
        exact h_inj_pre this
      exact dense_iff_closure_eq.mpr h_closure_univ

end Meta

end PiBase

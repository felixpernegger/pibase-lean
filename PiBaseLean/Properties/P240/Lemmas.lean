module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P240.Defs

@[expose] public section

universe u

namespace PiBase

open Set

namespace Formal

/-- Images under a partial equivalence postcomposed with an equivalence. -/
theorem image_transEquiv {α β γ : Type*} (e : PartialEquiv α β) (g : β ≃ γ) (s : Set α) :
    e.transEquiv g '' s = g '' (e '' s) := by
  rw [PartialEquiv.coe_transEquiv, Set.image_comp]

end Formal

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.cWComplexSpace : WellDefined CWComplexSpace :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    refine ⟨h.cell_structure.map fun hX => ?_⟩
    exact {
      cell n := hX.cell n
      map n i := (hX.map n i).transEquiv φ.toEquiv
      source_eq n i := hX.source_eq n i
      continuousOn n i := by
        simpa only [PartialEquiv.coe_transEquiv, Homeomorph.coe_toEquiv] using
          φ.continuous.comp_continuousOn (hX.continuousOn n i)
      continuousOn_symm n i := by
        simp only [PartialEquiv.coe_transEquiv_symm, PartialEquiv.transEquiv_target]
        exact (hX.continuousOn_symm n i).comp φ.symm.continuous.continuousOn
          (mapsTo_preimage _ _)
      pairwiseDisjoint' := by
        intro a _ b _ hab
        simp only [Function.onFun, Formal.image_transEquiv]
        exact (Set.disjoint_image_iff φ.injective).mpr
          (hX.pairwiseDisjoint' (mem_univ a) (mem_univ b) hab)
      mapsTo' n i := by
        obtain ⟨I, hI⟩ := hX.mapsTo' n i
        refine ⟨I, fun x hx => ?_⟩
        have hmem := hI hx
        simp only [mem_iUnion] at hmem ⊢
        obtain ⟨m, hm, j, hj, hmem⟩ := hmem
        refine ⟨m, hm, j, hj, ?_⟩
        rw [Formal.image_transEquiv]
        exact ⟨_, hmem, rfl⟩
      closed' A _ hA := by
        rw [← φ.isClosed_preimage]
        refine hX.closed' _ (subset_univ _) fun n j => ?_
        have h1 := hA n j
        rw [Formal.image_transEquiv] at h1
        have h2 : φ ⁻¹' (A ∩ φ '' (hX.map n j '' Metric.closedBall 0 1))
            = φ ⁻¹' A ∩ hX.map n j '' Metric.closedBall 0 1 := by
          rw [Set.preimage_inter, Set.preimage_image_eq _ φ.injective]
        exact h2 ▸ h1.preimage φ.continuous
      union' := by
        calc
          ⋃ (n : ℕ) (j : hX.cell n),
              (hX.map n j).transEquiv φ.toEquiv '' Metric.closedBall 0 1
              = φ '' ⋃ (n : ℕ) (j : hX.cell n), hX.map n j '' Metric.closedBall 0 1 := by
                simp only [Formal.image_transEquiv, Homeomorph.coe_toEquiv, Set.image_iUnion]
          _ = φ '' (univ : Set _) := by rw [hX.union']
          _ = univ := by rw [Set.image_univ, φ.surjective.range_eq]
    }

end PiBase

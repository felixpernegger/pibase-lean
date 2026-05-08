module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P37.Lemmas
public import PiBaseLean.Properties.P40.Lemmas

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T38: P40 (UltraconnectedSpace) => P37 (PrepathConnectedSpace) -/
instance instPrepathConnectedSpaceOfUltraconnectedSpace (X : Type u)
    [TopologicalSpace X] [h : UltraconnectedSpace X] : PrepathConnectedSpace X where
  joined x y := by
    obtain ⟨p , px, py⟩ := h.ultraconnected (closure {x}) (closure {y})
      isClosed_closure isClosed_closure (by simp) (by simp)
    let f : unitInterval → X := fun i ↦ if i.val < 0.5 then x else if i.val = 0.5 then p else y
    refine ⟨⟨f, ?_⟩, by norm_num [f], by norm_num [f]⟩
    apply continuous_iff_isClosed.mpr (fun s hs ↦ ?_)
    by_cases sx : x ∈ s
    · have ps : p ∈ s := by
        apply mem_of_mem_of_subset px
        exact hs.mem_iff_closure_subset.mp sx
      by_cases sy : y ∈ s
      · have : f ⁻¹' s = univ := by
          ext i
          simp only [mem_preimage, mem_univ, iff_true, f]
          by_cases hi : i.val < 0.5
          · simp only [hi, ↓reduceIte, sx]
          by_cases hi' : i.val = 0.5
          · have tmp : i = ⟨0.5, by norm_num⟩ := by ext; exact hi'
            rw [tmp]
            simpa only [lt_self_iff_false, ↓reduceIte]
          simp only [hi, ↓reduceIte, hi', sy]
        rw [this]
        exact isClosed_univ
      have : f ⁻¹' s = Icc 0 ⟨0.5, by norm_num⟩ := by
        ext i
        simp only [mem_preimage, mem_Icc, zero_le', true_and, f]
        by_cases hi : i.val < 0.5
        · simp only [hi, ↓reduceIte, sx, true_iff]
          exact le_of_lt hi
        by_cases hi' : i.val = 0.5
        · have tmp : i = ⟨0.5, by norm_num⟩ := by ext; exact hi'
          rw [tmp]
          simpa
        simp only [hi, ↓reduceIte, hi', sy, false_iff]
        contrapose! hi
        exact lt_of_le_of_ne hi hi'
      rw [this]
      exact isClosed_Icc
    by_cases sy : y ∈ s
    · have ps : p ∈ s := by
        apply mem_of_mem_of_subset py
        exact hs.mem_iff_closure_subset.mp sy
      have : f ⁻¹' s = Icc ⟨0.5, by norm_num⟩ 1 := by
        ext i
        simp only [mem_preimage, mem_Icc, f]
        by_cases hi : i.val < 0.5
        · simp only [hi, ↓reduceIte, sx, false_iff, not_and, not_le]
          intro h
          contrapose! h
          exact hi
        by_cases hi' : i.val = 0.5
        · have tmp : i = ⟨0.5, by norm_num⟩ := by ext; exact hi'
          rw [tmp]
          simp only [lt_self_iff_false, ↓reduceIte, ps, Std.le_refl, true_and, true_iff, ge_iff_le]
          exact unitInterval.le_one'
        simp only [hi, ↓reduceIte, hi', sy, true_iff]
        refine ⟨?_, unitInterval.le_one'⟩
        contrapose! hi
        exact lt_of_lt_of_eq hi rfl
      rw [this]
      exact isClosed_Icc
    by_cases sp : p ∈ s
    · have : f ⁻¹' s = {⟨0.5, by norm_num⟩} := by
        ext i
        simp only [mem_preimage, mem_singleton_iff, f]
        by_cases hi : i.val < 0.5
        · simp only [hi, ↓reduceIte, sx, false_iff]
          exact ne_of_lt hi
        by_cases hi' : i.val = 0.5
        · have tmp : i = ⟨0.5, by norm_num⟩ := by ext; exact hi'
          rw [tmp]
          simpa
        simp only [hi, ↓reduceIte, hi', sy, false_iff]
        exact Subtype.coe_ne_coe.mp hi'
      rw [this]
      apply Finite.isClosed
      simp
    have : f ⁻¹' s = ∅ := by
      ext i
      simp only [mem_preimage, mem_empty_iff_false, iff_false, f]
      by_cases hi : i.val < 0.5
      · simpa [hi]
      by_cases hi' : i.val = 0.5
      · have tmp : i = ⟨0.5, by norm_num⟩ := by ext; exact hi'
        rw [tmp]
        simpa
      simpa [hi, hi']
    rw [this]
    exact isClosed_empty

end PiBase

namespace PiBase.Formal

theorem T38 : P40 ≤ P37 := fun X _ ↦ @instPrepathConnectedSpaceOfUltraconnectedSpace X _

end PiBase.Formal

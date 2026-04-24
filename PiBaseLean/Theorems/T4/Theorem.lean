module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P19.Defs
public import PiBaseLean.Properties.P22.Defs
public import Mathlib

@[expose] public section

open Topology Set Function TopologicalSpace

namespace PiBase

/- Theorem 4, countably compact implies pseudocompact -/
instance instPseudocompactSpaceOfCountablyCompactSpace
    {X : Type*} [TopologicalSpace X] [h : CountablyCompactSpace X] :
    PseudocompactSpace X where
  pseudocompact f hf := by
    /- have countableOpenCover := isCountablyCompact_iff_countable_open_cover.mp  -/
    let S (n : ℕ) : Set ℝ := Set.Ioo (-n : ℝ) (n : ℝ)
    let preim (n : ℕ) : Set X := Set.preimage f (S n)
    let hh := isOpen_Ioo (a := (-1 : ℝ)) (b := (1 : ℝ))
    let Sn_open (n : ℕ) : IsOpen (S n) := by
      unfold S
      exact isOpen_Ioo
    let preim_open (n : ℕ) : IsOpen (preim n) :=
      (continuous_def.mp hf) (S n) (Sn_open n)

    have S_union : (Set.univ : Set ℝ) = (⋃ (i : ℕ), S i) := by
      ext x
      constructor
      · simp only [mem_univ, mem_iUnion, forall_const]
        use ⌈|x|⌉₊ + 1
        unfold S
        simp only [Set.mem_Ioo]

        -- AI stuff
        have h1 : |x| < ↑(⌈|x|⌉₊ + 1) := by
          calc |x| ≤ ↑⌈|x|⌉₊ := Nat.le_ceil |x|
          _ < ↑(⌈|x|⌉₊ + 1) := by norm_num
        constructor
        · -- goal: -↑(⌈|x|⌉₊ + 1) < x
          linarith [neg_abs_le x]
        · -- goal: x < ↑(⌈|x|⌉₊ + 1)
          linarith [le_abs_self x]
        -- AI stuff ends

      · simp

    let h_cover : (Set.univ : Set X) ⊆ ⋃ (i : ℕ), preim i := by sorry

    have X_IsCountablyCompact : IsCountablyCompact (Set.univ : Set X) := CountablyCompactSpace.isCountablyCompact_univ
    have finite_subcover_ofX := isCountablyCompact_iff_countable_open_cover.mp X_IsCountablyCompact preim preim_open h_cover
    obtain ⟨t, ht⟩ := finite_subcover_ofX

    have ht_nonempty : t.Nonempty := sorry
    /- let t_max : ℕ := t.max' ht_nonempty -/

    /- have t_max_covers_X : ⋃ (i ∈ t), S i ⊆ S t_max := by -/
    /-   intro x hx -/
    /-   unfold S t_max -/

    /- have h_range : range f ⊆ (S t_max) := by -/
    /-   intro y hy -/
    /-   unfold range at hy -/
      
      
      

      sorry
    



    


    sorry

end PiBase

namespace PiBase.Formal

theorem T4 : P19 ≤ P22 := @instPseudocompactSpaceOfCountablyCompactSpace

end PiBase.Formal

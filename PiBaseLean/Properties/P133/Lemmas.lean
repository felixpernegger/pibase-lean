module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P133.Defs
public import Mathlib.Topology.Connected.PathConnected

@[expose] public section

namespace PiBase

open Topology Filter Set TopologicalSpace

variable {X Y : Type*} [t : TopologicalSpace X] [s : TopologicalSpace Y]

section Meta

/- TODO (horrible)
theorem Homeomorph.lots [h : Lots X] (f : X ≃ₜ Y) : Lots Y where
  from_linear_order := by
    obtain ⟨τ, hτ⟩ := h
    let σ : LinearOrder Y :={
      le x y := f.symm x ≤ f.symm y
      le_refl x := le_refl (f.symm x)
      le_trans x y z xy yz :=
        Std.IsPreorder.le_trans (f.symm x) (f.symm y) (f.symm z) xy yz
      lt_iff_le_not_ge := fun _ _ ↦ Iff.of_eq rfl
      le_antisymm x y xy yz := by
        apply f.symm.injective
        exact le_antisymm (a := f.symm x) (b := f.symm y) xy yz
      le_total := by exact fun a b ↦ Std.IsLinearPreorder.le_total (f.symm a) (f.symm b)
      toDecidableLE := by apply Classical.decRel
      min_def := by simp
      max_def := by simp
      compare_eq_compareOfLessAndEq := by simp
    }
    have pr : ∀ {x y : Y}, f.symm x < f.symm y ↔ x < y := by
      intro x y
      refine ⟨fun xy ↦ ?_, fun xy ↦ ?_⟩
      · refine Std.lt_iff_le_and_ne.mpr ⟨?_, ?_⟩
        · exact xy.le
        contrapose! xy
        rw [xy]
      · contrapose! xy
        exact xy
    have pr'' : ∀ {x y : X}, x < y ↔ f x < f y := by
      intro x y
      nth_rw 1 [← f.symm_apply_apply x, ← f.symm_apply_apply y]
      exact Iff.symm ((fun {a b} ↦ iff_comm.mp) pr)
    refine ⟨σ, ?_⟩
    refine { topology_eq_generate_intervals := ?_ }
    have : {s : Set Y | ∃ a, s = Ioi a ∨ s = Iio a}
        = {s : Set Y | ∃ a : X, s = Ioi (f a) ∨ s = Iio (f a)} := by
      ext u
      simp only [mem_setOf_eq]
      refine ⟨fun h ↦ ?_, fun h ↦ ?_⟩
      · obtain ⟨a, ha⟩ := h
        rcases ha with h|h
        · rw [h]
          refine ⟨f.symm a, ?_⟩
          left
          simp
        · rw [h]
          refine ⟨f.symm a, ?_⟩
          right
          simp
      · obtain ⟨a, ha⟩ := h
        rcases ha with h|h
        · rw [h]
          refine ⟨f a, ?_⟩
          left
          simp
        · rw [h]
          refine ⟨f a, ?_⟩
          right
          simp
    rw [this]
    refine (ext_nhds fun y ↦ ?_)
    ext l
    have fac := hτ.topology_eq_generate_intervals
    have hl : f ⁻¹' l ∈ 𝓝 (f.symm y) ↔
        f ⁻¹' l ∈ @nhds X (generateFrom {s | ∃ a, s = Ioi a ∨ s = Iio a}) (f.symm y) := by
      rw [← fac]
    rw [nhds_generateFrom] at hl ⊢
    simp only [mem_setOf_eq] at hl ⊢
    refine ⟨fun h ↦ ?_, fun h ↦ ?_⟩
    · have : ⇑f ⁻¹' l ∈ 𝓝 (f.symm y) := by
        refine ContinuousAt.preimage_mem_nhds ?_ ?_
        · exact map_continuousAt f (f.symm y)
        · simpa
      replace this := hl.1 this
      rw [mem_iInf] at this ⊢
      obtain ⟨I, I_fin, V, hV, eq⟩ := this
      refine ⟨(Set.image f) '' I, ?_, ?_⟩
      · exact Finite.image (image ⇑f) I_fin
      let V : ↑(image ⇑f '' I) → Set Y :=
        fun (⟨s, hs⟩ : ↑(image ⇑f '' I)) ↦ by
          --obtain ⟨o, ho⟩ := (mem_image (image f) I s).1 hs
          exact ∅
      refine ⟨V, ?_, ?_⟩
      · intro ⟨j, hj⟩
        simp only

        #check Filter.mem_iInf
        sorry
      sorry
    have : ⇑f ⁻¹' l ∈  ⨅ s_1, ⨅ (_ : f.symm y ∈ s_1 ∧ ∃ a, s_1 = Ioi a ∨ s_1 = Iio a), 𝓟 s_1 := by
      rw [mem_iInf] at h ⊢

      sorry
    replace this := hl.2 this
    rw [mem_nhds_iff] at this ⊢
    obtain ⟨r, rl, ro, yr⟩ := this
    refine ⟨f '' r, ?_, ?_, ?_⟩
    · exact image_subset_iff.mpr rl
    · exact (Homeomorph.isOpen_image f).mpr ro
    · simp only [mem_image]
      exact ⟨f.symm y, yr, by simp⟩

    /-
    refine TopologicalSpace.IsTopologicalBasis.eq_generateFrom ?_
    refine isTopologicalBasis_of_isOpen_of_nhds (fun u hu ↦ ?_) fun y u yu hu ↦ ?_
    · obtain ⟨a, ha⟩ := hu
      apply Or.elim ha <;> intro h <;> rw [h] <;> apply (Homeomorph.isOpen_image f.symm).mp
      · have : f.symm '' (Ioi a) = Ioi (f.symm a) := by
          ext i
          simp only [mem_image, mem_Ioi]
          refine ⟨fun hi ↦ ?_, fun hi ↦ ?_⟩
          · obtain ⟨x, ax, hx⟩ := hi
            rw [← hx]
            exact pr.mpr ax
          refine ⟨f i, ?_, f.symm_apply_apply i⟩
          rw [← f.apply_symm_apply a]
          exact pr''.mp hi
        rw [this]
        exact isOpen_Ioi
      · have : f.symm '' (Iio a) = Iio (f.symm a) := by
          ext i
          simp only [mem_image, mem_Iio]
          refine ⟨fun hi ↦ ?_, fun hi ↦ ?_⟩
          · obtain ⟨x, ax, hx⟩ := hi
            rw [← hx]
            exact pr.mpr ax
          refine ⟨f i, ?_, f.symm_apply_apply i⟩
          rw [← f.apply_symm_apply a]
          exact pr''.mp hi
        rw [this]
        exact isOpen_Iio
    have fu : IsOpen (f ⁻¹' u) := (Homeomorph.isOpen_preimage f).mpr hu

    have : ∀ y ∈ f ⁻¹' u, ∃ v ∈ {s | ∃ a, s = Ioi a ∨ s = Iio a}, y ∈ v ∧ v ⊆ f ⁻¹' u := by
      intro y hy
      refine (IsTopologicalBasis.mem_nhds_iff ?_).mp <| (IsOpen.mem_nhds_iff fu).mpr hy
      --nope
      sorry
    sorry -/
    sorry

theorem WellDefined.lots : WellDefined Lots :=
  sorry

end Meta

end PiBase

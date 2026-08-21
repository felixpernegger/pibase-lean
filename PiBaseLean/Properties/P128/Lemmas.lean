module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P128.Defs

@[expose] public section

namespace PiBase

open Set TopologicalSpace

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.kLindelofSpace : WellDefined KLindelofSpace :=
  fun {X Y} _ _ hXY h => by
    let φ := hXY.some
    constructor
    intro ι f hf
    have h_open_pre : ∀ i, IsOpen (φ ⁻¹' (↑(f i) : Set Y)) :=
      fun i => φ.isOpen_preimage.mpr (f i).2
    let f' : ι → Opens X := fun i => ⟨φ ⁻¹' (↑(f i) : Set Y), h_open_pre i⟩
    have hf'_cover : IsOpenCover f' := by
      have h_union : (⋃ i, φ ⁻¹' (↑(f i) : Set Y)) = univ := by
        calc
          ⋃ i, φ ⁻¹' (↑(f i) : Set Y) = φ ⁻¹' (⋃ i, (↑(f i) : Set Y)) := by
            rw [preimage_iUnion]
          _ = φ ⁻¹' univ := by rw [hf.1.iSup_set_eq_univ]
          _ = univ := preimage_univ
      exact IsOpenCover.of_sets h_open_pre h_union
    have hf'_notop : (⊤ : Opens X) ∉ range f' := by
      intro h_top
      obtain ⟨i, hi⟩ := h_top
      have h_f'_i_univ : (↑(f' i) : Set X) = univ := by
        calc
          (↑(f' i) : Set X) = (↑(⊤ : Opens X) : Set X) := by rw [hi]
          _ = univ := by rfl
      have h_pre_univ : φ ⁻¹' (↑(f i) : Set Y) = univ := by
        have : (↑(f' i) : Set X) = φ ⁻¹' (↑(f i) : Set Y) := rfl
        rw [this] at h_f'_i_univ
        exact h_f'_i_univ
      have h_fi_univ_set : (↑(f i) : Set Y) = univ := by
        ext y
        simp only [mem_univ, iff_true]
        obtain ⟨x, rfl⟩ := φ.surjective y
        have hx : x ∈ φ ⁻¹' (↑(f i) : Set Y) := by
          rw [h_pre_univ]
          trivial
        exact hx
      have h_fi_eq_top : f i = ⊤ := Opens.ext (by simp [h_fi_univ_set])
      exact hf.2.1 ⟨i, h_fi_eq_top⟩
    have hf'_compact : ∀ ⦃K : Set X⦄, IsCompact K → ∃ i, K ⊆ f' i := by
      intro K hK
      have hK' : IsCompact (φ '' K) := hK.image φ.continuous
      obtain ⟨i, hi⟩ := hf.2.2 hK'
      refine ⟨i, ?_⟩
      intro x hx
      exact hi (mem_image_of_mem φ hx)
    have hf'_isKCover : IsKCover f' := ⟨hf'_cover, hf'_notop, hf'_compact⟩
    obtain ⟨ω, g, hCount, hgK, hgRange⟩ := h.ex_kSubcover hf'_isKCover
    let g' : ω → Opens Y := fun j => ⟨φ '' (↑(g j) : Set X), φ.isOpen_image.mpr (g j).2⟩
    have hg'_cover : IsOpenCover g' := by
      have hg_union : (⋃ j, (↑(g j) : Set X)) = univ := hgK.1.iSup_set_eq_univ
      have h_union_g' : (⋃ j, φ '' (↑(g j) : Set X)) = univ := by
        ext y
        simp only [mem_iUnion, mem_univ, iff_true]
        obtain ⟨x, rfl⟩ := φ.surjective y
        have hx : x ∈ ⋃ j, (↑(g j) : Set X) := by rw [hg_union]; trivial
        obtain ⟨j, hj⟩ := mem_iUnion.mp hx
        exact ⟨j, mem_image_of_mem φ hj⟩
      exact IsOpenCover.of_sets (fun j => φ.isOpen_image.mpr (g j).2) h_union_g'
    have hg'_notop : (⊤ : Opens Y) ∉ range g' := by
      intro h_top
      obtain ⟨j, hj⟩ := h_top
      have h_g'_j_univ : (↑(g' j) : Set Y) = univ := by
        calc
          (↑(g' j) : Set Y) = (↑(⊤ : Opens Y) : Set Y) := by rw [hj]
          _ = univ := by rfl
      have h_img_univ : φ '' (↑(g j) : Set X) = univ := h_g'_j_univ
      have h_gj_univ : (↑(g j) : Set X) = univ := by
        have h_pre : φ ⁻¹' (φ '' (↑(g j) : Set X)) = (↑(g j) : Set X) := φ.preimage_image _
        rw [h_img_univ, preimage_univ] at h_pre
        exact h_pre.symm
      have : g j = ⊤ := Opens.ext (by simp [h_gj_univ])
      exact hgK.2.1 ⟨j, this⟩
    have hg'_compact : ∀ ⦃K : Set Y⦄, IsCompact K → ∃ j, K ⊆ g' j := by
      intro K hK
      have hK_pre : IsCompact (φ ⁻¹' K) := (Homeomorph.isCompact_preimage φ).mpr hK
      obtain ⟨j, hj⟩ := hgK.2.2 hK_pre
      refine ⟨j, ?_⟩
      intro y hy
      obtain ⟨x, rfl⟩ := φ.surjective y
      exact mem_image_of_mem φ (hj hy)
    have hg'_isKCover : IsKCover g' := ⟨hg'_cover, hg'_notop, hg'_compact⟩
    refine ⟨ω, g', hCount, hg'_isKCover, ?_⟩
    intro o ho
    obtain ⟨j, rfl⟩ := ho
    have hg_mem : g j ∈ range f' := hgRange ⟨j, rfl⟩
    obtain ⟨i, hi⟩ := hg_mem
    have h_eq_set : (↑(g j) : Set X) = φ ⁻¹' (↑(f i) : Set Y) := by
      have := congrArg (fun o : Opens X => (↑o : Set X)) hi
      simpa [f'] using this.symm
    have h_g'_eq_set : (↑(g' j) : Set Y) = (↑(f i) : Set Y) := by
      calc
        (↑(g' j) : Set Y) = φ '' (↑(g j) : Set X) := rfl
        _ = φ '' (φ ⁻¹' (↑(f i) : Set Y)) := by rw [h_eq_set]
        _ = (↑(f i) : Set Y) := φ.image_preimage _
    exact ⟨i, Opens.ext h_g'_eq_set.symm⟩

end PiBase

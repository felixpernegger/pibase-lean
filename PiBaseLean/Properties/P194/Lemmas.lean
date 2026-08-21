module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P194.Defs

@[expose] public section

namespace PiBase

open Set

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.submetacompactSpace : WellDefined SubmetacompactSpace :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    constructor
    intro α s hs_open hs_cover
    have hs_open_X : ∀ a, IsOpen (φ ⁻¹' (s a)) := fun a => (hs_open a).preimage φ.continuous
    have hs_cover_X : ⋃ a, φ ⁻¹' (s a) = univ := by
      ext x
      simp only [mem_iUnion, mem_preimage, mem_univ, iff_true]
      have : φ x ∈ ⋃ a, s a := by rw [hs_cover]; trivial
      exact mem_iUnion.mp this
    obtain ⟨ω, t, ht⟩ := h.ex_seq α (fun a => φ ⁻¹' (s a)) hs_open_X hs_cover_X
    refine ⟨ω, fun n b => φ '' (t n b), ?_⟩
    constructor
    · intro n
      constructor
      · intro b
        exact φ.isOpenMap _ ((ht.1 n).1 b)
      constructor
      · ext y
        simp only [mem_iUnion, mem_image, mem_univ, iff_true]
        have : φ.symm y ∈ ⋃ a, t n a := by rw [(ht.1 n).2.1]; trivial
        obtain ⟨a, ha⟩ := mem_iUnion.mp this
        exact ⟨a, φ.symm y, ha, by simp⟩
      · intro b
        obtain ⟨a, ha⟩ := (ht.1 n).2.2 b
        exact ⟨a, (Set.image_mono ha).trans (Set.image_preimage_subset φ (s a))⟩
    · intro y
      obtain ⟨n, hn⟩ := ht.2 (φ.symm y)
      refine ⟨n, ?_⟩
      -- PointFiniteAt (t n) (φ.symm y) means {i | φ.symm y ∈ t n i} finite
      -- Need {i | y ∈ φ '' t n i} finite
      -- y ∈ φ '' t n i ↔ φ.symm y ∈ t n i
      have h_equiv : {i | y ∈ φ '' (t n i)} = {i | φ.symm y ∈ t n i} := by
        ext i
        simp only [mem_ofPred_eq, mem_image]
        constructor
        · rintro ⟨x, hx, rfl⟩
          simpa using hx
        · intro hi
          exact ⟨φ.symm y, hi, by simp⟩
      change {i | y ∈ φ '' (t n i)}.Finite
      rw [h_equiv]
      exact hn

end PiBase

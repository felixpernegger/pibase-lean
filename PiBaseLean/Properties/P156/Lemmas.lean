module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P156.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.kRothbergerSpace : WellDefined KRothbergerSpace :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    constructor
    intro ι U hU_kcover
    let U' : ℕ → ι → Set _ := fun n i => φ ⁻¹' (U n i)
    have hU'_kcover : ∀ n, IsKCover'' (U' n) := by
      intro n
      obtain ⟨hOpen, hUnion, hNotTop, hComp⟩ := hU_kcover n
      refine ⟨fun i => φ.isOpen_preimage.mpr (hOpen i), ?_, ?_, ?_⟩
      · have : (⋃ i, U' n i) = φ ⁻¹' (⋃ i, U n i) := by simp [U', Set.preimage_iUnion]
        rw [this, hUnion, Set.preimage_univ]
      · intro h_mem
        obtain ⟨i, hi⟩ := h_mem
        have h_univ : U n i = _root_.Set.univ := by
          have h_eq : φ ⁻¹' (U n i) = _root_.Set.univ := hi
          calc U n i = φ '' (φ ⁻¹' (U n i)) := (φ.image_preimage _).symm
            _ = φ '' _root_.Set.univ := by rw [h_eq]
            _ = _root_.Set.univ := Set.image_univ_of_surjective φ.surjective
        exact hNotTop ⟨i, by ext y; simp [h_univ]⟩
      · intro K hK
        have hK' : IsCompact (φ '' K) := hK.image φ.continuous
        obtain ⟨i, hi⟩ := hComp hK'
        exact ⟨i, fun x hx => hi ⟨x, hx, rfl⟩⟩
    obtain ⟨j, hj⟩ := h.k_rothberger U' hU'_kcover
    refine ⟨j, ?_⟩
    obtain ⟨hOpen', hUnion', hNotTop', hComp'⟩ := hj
    refine ⟨fun n => φ.isOpen_preimage.mp (hOpen' n), ?_, ?_, ?_⟩
    · have : (⋃ n, U n (j n)) = φ '' (⋃ n, U' n (j n)) := by
        rw [Set.image_iUnion]
        simp only [U', φ.image_preimage]
      rw [this, hUnion', Set.image_univ_of_surjective φ.surjective]
    · intro h_mem
      obtain ⟨n, hn⟩ := h_mem
      have h_univ' : U' n (j n) = _root_.Set.univ := by
        have : (fun n => U n (j n)) n = _root_.Set.univ := hn
        simp [U', this]
      exact hNotTop' ⟨n, h_univ'⟩
    · intro K hK
      have hK_pre : IsCompact (φ ⁻¹' K) := by
        have h_eq : φ ⁻¹' K = φ.symm '' K := by
          ext x; constructor
          · intro hx; exact ⟨φ x, hx, by simp⟩
          · rintro ⟨y, hy, rfl⟩; simp [hy]
        rw [h_eq]
        exact hK.image φ.symm.continuous
      obtain ⟨n, hn⟩ := hComp' hK_pre
      exact ⟨n, by calc K = φ '' (φ ⁻¹' K) := (φ.image_preimage K).symm
        _ ⊆ φ '' (U' n (j n)) := Set.image_mono hn
        _ = U n (j n) := φ.image_preimage _⟩

end PiBase

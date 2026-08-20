module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P159.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.kMengerSpace : WellDefined KMengerSpace :=
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
        have h_eq : φ ⁻¹' (U n i) = _root_.Set.univ := hi
        have h_univ : U n i = _root_.Set.univ := by
          calc U n i = φ '' (φ ⁻¹' (U n i)) := (φ.image_preimage _).symm
            _ = φ '' _root_.Set.univ := by rw [h_eq]
            _ = _root_.Set.univ := Set.image_univ_of_surjective φ.surjective
        exact hNotTop ⟨i, by ext y; simp [h_univ]⟩
      · intro K hK
        have hK' : IsCompact (φ '' K) := hK.image φ.continuous
        obtain ⟨i, hi⟩ := hComp hK'
        exact ⟨i, fun x hx => hi ⟨x, hx, rfl⟩⟩
    obtain ⟨s, hs⟩ := h.k_menger U' hU'_kcover
    refine ⟨s, ?_⟩
    obtain ⟨hOpen', hUnion', hNotTop', hComp'⟩ := hs
    refine ⟨?_, ?_, ?_, ?_⟩
    · intro t ht
      obtain ⟨n, i, hi, rfl⟩ := ht
      exact φ.isOpen_preimage.mp (hOpen' (U' n i) ⟨n, i, hi, rfl⟩)
    · have h_pre : (⋃₀ {U' n i | (n : ℕ) (i : ι) (_ : i ∈ s n)} : Set _) =
          _root_.Set.univ := hUnion'
      have h_eq_pre : φ ⁻¹' (⋃₀ {U n i | (n : ℕ) (i : ι) (_ : i ∈ s n)} : Set _)
          = ⋃₀ {U' n i | (n : ℕ) (i : ι) (_ : i ∈ s n)} := by
        ext x
        simp only [Set.mem_preimage, Set.mem_sUnion, Set.mem_ofPred_eq]
        constructor
        · rintro ⟨_, ⟨n, i, hi, rfl⟩, hx⟩
          exact ⟨U' n i, ⟨n, i, hi, rfl⟩, hx⟩
        · rintro ⟨_, ⟨n, i, hi, rfl⟩, hx⟩
          exact ⟨U n i, ⟨n, i, hi, rfl⟩, hx⟩
      have h_pre' : φ ⁻¹' (⋃₀ {U n i | (n : ℕ) (i : ι) (_ : i ∈ s n)} : Set _) =
          _root_.Set.univ := by
        rw [h_eq_pre]; exact h_pre
      ext y
      refine ⟨fun _ => Set.mem_univ y, fun _ => ?_⟩
      obtain ⟨x, rfl⟩ := φ.surjective y
      have hx : x ∈ φ ⁻¹' (⋃₀ {U n i | (n : ℕ) (i : ι) (_ : i ∈ s n)} : Set _) := by
        rw [h_pre']; exact Set.mem_univ x
      exact hx
    · intro h_mem
      obtain ⟨n, i, hi, heq⟩ := h_mem
      have : U n i = _root_.Set.univ := by ext y; simp [heq]
      have h_mem' : _root_.Set.univ ∈ {U' n i | (n : ℕ) (i : ι) (_ : i ∈ s n)} := by
        refine ⟨n, i, hi, ?_⟩
        simp [U', this]
      exact hNotTop' h_mem'
    · intro K hK
      have hK_pre : IsCompact (φ ⁻¹' K) := by
        have h_eq : φ ⁻¹' K = φ.symm '' K := by
          ext x; constructor
          · intro hx; exact ⟨φ x, hx, by simp⟩
          · rintro ⟨y, hy, rfl⟩; simp [hy]
        rw [h_eq]
        exact hK.image φ.symm.continuous
      obtain ⟨t, ht_mem, ht_sub⟩ := hComp' hK_pre
      obtain ⟨n, i, hi, rfl⟩ := ht_mem
      refine ⟨U n i, ⟨n, i, hi, rfl⟩, ?_⟩
      calc K = φ '' (φ ⁻¹' K) := (φ.image_preimage K).symm
        _ ⊆ φ '' (U' n i) := Set.image_mono ht_sub
        _ = U n i := φ.image_preimage _

end Meta

end PiBase

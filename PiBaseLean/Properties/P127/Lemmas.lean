module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P127.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace


section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.dowkerSpace : WellDefined DowkerSpace :=
  fun {X Y} _ _ hXY h => by
    let φ := hXY.some
    have hT4 : T4Space _ := φ.t4Space
    refine @DowkerSpace.mk _ _ hT4 ?_
    intro hY
    apply h.not_countably_paracompact
    -- Show CountablyParacompact X via transfer from Y
    -- hY : CountablyParacompactSpace Y
    constructor
    intro α s hs_open hs_cover hCount
    -- Transfer open cover to Y
    have hs_open' : ∀ a, IsOpen (φ '' (s a)) := fun a => φ.isOpen_image.mpr (hs_open a)
    have hs_cover' : (⋃ a, φ '' (s a) : Set _) = univ := by
      rw [← image_iUnion]
      rw [hs_cover]
      exact image_univ_of_surjective φ.surjective
    obtain ⟨β, t, ht_open, ht_cover, ht_lf, ht_ref⟩ :=
      hY.countably_paracompact α (fun a => φ '' s a) hs_open' hs_cover' hCount
    -- Pull back refinement to X
    refine ⟨β, fun b => φ ⁻¹' (t b), fun b => φ.isOpen_preimage.mpr (ht_open b), ?_, ?_, ?_⟩
    · -- cover
      have : (⋃ b, φ ⁻¹' (t b) : Set _) = φ ⁻¹' (⋃ b, t b) := by simp [preimage_iUnion]
      rw [this, ht_cover, preimage_univ]
    · -- locally finite
      intro x
      -- φ x ∈ Y, get neighborhood with finite intersecting indices
      obtain ⟨U, hU_nhds, hU_fin⟩ := ht_lf (φ x)
      refine ⟨φ ⁻¹' U, φ.continuous.continuousAt.preimage_mem_nhds hU_nhds, ?_⟩
      -- Show finiteness of {b | (φ⁻¹' t b ∩ φ⁻¹' U).Nonempty} equals that of t
      have h_eq : {b | ((φ ⁻¹' (t b) ∩ φ ⁻¹' U : Set _).Nonempty)} =
          {b | ((t b ∩ U).Nonempty)} := by
        ext b
        simp only [mem_ofPred_eq, Set.Nonempty, mem_inter_iff, mem_preimage]
        constructor
        · rintro ⟨z, ⟨htb, hU⟩⟩
          refine ⟨φ z, ⟨?_, ?_⟩⟩
          · exact htb
          · exact hU
        · rintro ⟨y, ⟨htb, hU⟩⟩
          obtain ⟨z, rfl⟩ := φ.surjective y
          refine ⟨z, ⟨?_, ?_⟩⟩
          · simpa using htb
          · simpa using hU
      rw [h_eq]
      exact hU_fin
    · -- refinement
      intro b
      obtain ⟨a, ha⟩ := ht_ref b
      refine ⟨a, ?_⟩
      have : φ ⁻¹' (t b) ⊆ φ ⁻¹' (φ '' (s a)) := Set.preimage_mono ha
      rwa [φ.preimage_image] at this

end Meta

end PiBase

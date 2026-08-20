module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P244.Defs
public import Mathlib.Topology.Homeomorph.Lemmas
public import Mathlib.Data.Set.Countable

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

open Topology Set Filter

section Meta


variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.hasCountablePiCharacter : WellDefined HasCountablePiCharacter :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    constructor
    intro y
    let x := φ.symm y
    obtain ⟨s, hsEmpty, hsOpen, hsCount, hsBase⟩ := h.countable_local_pi_base x
    let s' : Set (Set _) := (fun t => φ '' t) '' s
    have hsCount' : s'.Countable := hsCount.image _
    have hsEmpty' : ∅ ∉ s' := by
      intro hMem
      obtain ⟨a, ha, haEq⟩ := hMem
      have hA_eq_empty : a = ∅ := Set.image_eq_empty.mp haEq
      exact hsEmpty (hA_eq_empty ▸ ha)
    have hsOpen' : ∀ b ∈ s', IsOpen b := by
      intro b hb
      obtain ⟨a, ha, rfl⟩ := hb
      exact φ.isOpenMap _ (hsOpen a ha)
    refine ⟨s', hsEmpty', hsOpen', hsCount', fun U hU => ?_⟩
    have h_map : Filter.map φ (𝓝 x) = 𝓝 (φ x) := φ.map_nhds_eq x
    have h_eq : φ x = y := φ.apply_symm_apply y
    have hU_map : U ∈ Filter.map φ (𝓝 x) := by
      rw [h_map, h_eq]
      exact hU
    have hPre_mem : φ ⁻¹' U ∈ 𝓝 x := by
      rwa [Filter.mem_map] at hU_map
    obtain ⟨t, htMem, htSub⟩ := hsBase (φ ⁻¹' U) hPre_mem
    refine ⟨φ '' t, ⟨t, htMem, rfl⟩, ?_⟩
    calc φ '' t ⊆ φ '' (φ ⁻¹' U) := Set.image_mono htSub
      _ ⊆ U := Set.image_preimage_subset _ _

end Meta

end PiBase

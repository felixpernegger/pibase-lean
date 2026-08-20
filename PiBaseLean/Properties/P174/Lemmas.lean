module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P174.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta


variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.wellBasedSpace : WellDefined WellBasedSpace :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    refine ⟨fun y => ?_⟩
    obtain ⟨ι, s, hs_mem, hs_basis, hs_ord⟩ := h.basis_ordered (φ.symm y)
    refine ⟨ι, fun i => φ '' (s i), fun i => ⟨φ.symm y, hs_mem i, by simp⟩, ?_, ?_⟩
    · have hmap : Filter.map φ (𝓝 (φ.symm y)) = 𝓝 y := by
        rw [φ.map_nhds_eq, Homeomorph.apply_symm_apply]
      rw [← hmap]
      exact hs_basis.map φ
    · intro i j
      rcases hs_ord i j with hij | hij
      · exact Or.inl (Set.image_mono hij)
      · exact Or.inr (Set.image_mono hij)

end Meta

end PiBase

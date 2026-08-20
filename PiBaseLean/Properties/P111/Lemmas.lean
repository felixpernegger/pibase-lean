module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P111.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta


variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.hemicompactSpace : WellDefined HemicompactSpace :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    obtain ⟨ι, K, hCount, hComp, hUniv, hCof⟩ := h.hemicompact
    refine ⟨⟨ι, fun i => φ '' K i, hCount, ?_, ?_, ?_⟩⟩
    · exact fun i => IsCompact.image (hComp i) φ.continuous
    · rw [← image_iUnion, hUniv, image_univ, EquivLike.range_eq_univ]
    · intro t ht
      have ht' : IsCompact (φ.symm '' t) := IsCompact.image ht φ.symm.continuous
      obtain ⟨i, hi⟩ := hCof _ ht'
      refine ⟨i, fun y hy => ?_⟩
      exact ⟨φ.symm y, hi ⟨y, hy, rfl⟩, φ.apply_symm_apply y⟩

end Meta

end PiBase

module

public import PiBaseLean.Properties.P120.Defs
public import PiBaseLean.Properties.P133.Lemmas

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.locallyOrderableSpace : WellDefined LocallyOrderableSpace :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    constructor
    intro y
    obtain ⟨s, hs_mem, hs_lots⟩ := h.ex_nbhd_lots (φ.symm y)
    refine ⟨φ '' s, ?_, ?_⟩
    · rw [← φ.apply_symm_apply y, ← φ.map_nhds_eq (φ.symm y)]
      exact Filter.mem_map.mpr (Filter.mem_of_superset hs_mem (Set.subset_preimage_image φ s))
    · have hHomeo : s ≃ₜ φ '' s := φ.image s
      exact WellDefined.lots.homeo hHomeo hs_lots

end PiBase

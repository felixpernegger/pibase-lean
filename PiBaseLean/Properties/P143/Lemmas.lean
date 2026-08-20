module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P143.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace


section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.weakT2Space : WellDefined WeakT2Space :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    constructor
    intro K tK f hfCont hComp hT2
    have h_eq : φ ⁻¹' (range f) = range (φ.symm ∘ f) := by
      ext x
      simp only [mem_preimage, mem_range, comp_apply]
      constructor
      · rintro ⟨y, hy⟩
        -- hy : f y = φ x, need φ.symm (f y) = x
        refine ⟨y, ?_⟩
        calc φ.symm (f y) = φ.symm (φ x) := by rw [hy]
        _ = x := φ.symm_apply_apply x
      · rintro ⟨y, hy⟩
        -- hy : φ.symm (f y) = x, need f y = φ x
        have : f y = φ x := by
          calc f y = φ (φ.symm (f y)) := (φ.apply_symm_apply (f y)).symm
          _ = φ x := by rw [hy]
        exact ⟨y, this⟩
    rw [← φ.isClosed_preimage]
    rw [h_eq]
    exact h.compact_closed tK (φ.symm.continuous.comp hfCont) hComp hT2

end Meta

end PiBase

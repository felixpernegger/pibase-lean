module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P40.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.ultraconnectedSpace : WellDefined UltraconnectedSpace :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    constructor
    intro s t hs ht hsN htN
    have hs_pre : IsClosed (φ ⁻¹' s) := φ.isClosed_preimage.mpr hs
    have ht_pre : IsClosed (φ ⁻¹' t) := φ.isClosed_preimage.mpr ht
    have hsN_pre : (φ ⁻¹' s).Nonempty := by
      obtain ⟨y, hy⟩ := hsN
      exact ⟨φ.symm y, by
        have : φ (φ.symm y) ∈ s := by
          rw [φ.apply_symm_apply]
          exact hy
        exact this⟩
    have htN_pre : (φ ⁻¹' t).Nonempty := by
      obtain ⟨y, hy⟩ := htN
      exact ⟨φ.symm y, by
        have : φ (φ.symm y) ∈ t := by
          rw [φ.apply_symm_apply]
          exact hy
        exact this⟩
    obtain ⟨x, hx⟩ := h.ultraconnected _ _ hs_pre ht_pre hsN_pre htN_pre
    have hx_inter : x ∈ φ ⁻¹' s ∩ φ ⁻¹' t := hx
    exact ⟨φ x, hx_inter.1, hx_inter.2⟩

end PiBase

module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P104.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.symmetrizableSpace : WellDefined SymmetrizableSpace :=
  fun {X Y} _ _ hXY h => by
    let φ := hXY.some
    obtain ⟨symX⟩ := h.nonempty_symmetric
    let : Symmetric X := symX.toSymmetric
    let symYCore : Symmetric Y :=
      { dist := fun y₁ y₂ => dist (φ.symm y₁) (φ.symm y₂)
        dist_nonneg := fun y₁ y₂ => symX.dist_nonneg _ _
        dist_self := fun y => symX.dist_self _
        dist_comm := fun y₁ y₂ => symX.dist_comm _ _
        eq_of_dist_eq_zero := fun {y₁ y₂} h0 => by
          have : φ.symm y₁ = φ.symm y₂ := symX.eq_of_dist_eq_zero h0
          exact φ.symm.injective this }
    let : Symmetric Y := symYCore
    let symY : SymmetricSpace Y :=
      { symYCore with
        isOpen_iff := fun s => by
          have h_pre : IsOpen (φ ⁻¹' s) ↔ IsOpen s := φ.isOpen_preimage
          constructor
          · intro hs y hy
            have hsX : IsOpen (φ ⁻¹' s) := h_pre.mpr hs
            have hyX : φ.symm y ∈ φ ⁻¹' s := by simp [hy]
            have hX := (symX.isOpen_iff (φ ⁻¹' s)).mp hsX (φ.symm y) hyX
            obtain ⟨ε, hε, hsub⟩ := hX
            refine ⟨ε, hε, ?_⟩
            intro y' hy'
            have : φ.symm y' ∈ φ ⁻¹' s := by
              apply hsub
              change dist (φ.symm y') (φ.symm y) ≤ ε at hy'
              exact hy'
            simpa using this
          · intro hsY
            apply h_pre.mp
            apply (symX.isOpen_iff _).mpr
            intro x hx
            obtain ⟨ε, hε, hsub⟩ := hsY (φ x) hx
            refine ⟨ε, hε, ?_⟩
            intro x' hx'
            apply hsub
            change dist (φ.symm (φ x')) (φ.symm (φ x)) ≤ ε
            change dist x' x ≤ ε at hx'
            simpa using hx' }
    exact ⟨⟨symY⟩⟩

end PiBase

module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P222.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.hasCofiniteTopology : WellDefined HasCofiniteTopology :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    constructor
    intro s
    have key : IsOpen s ↔ IsOpen (φ ⁻¹' s) := by
      constructor
      · intro hs; exact hs.preimage φ.continuous
      · intro hs
        have : s = φ '' (φ ⁻¹' s) := by rw [Homeomorph.image_preimage]
        rw [this]
        exact φ.isOpenMap _ hs
    rw [key, h.open_iff_cofinite (φ ⁻¹' s)]
    constructor
    · intro h1 hs_nonempty
      have hpre_nonempty : (φ ⁻¹' s).Nonempty := by
        obtain ⟨y, hy⟩ := hs_nonempty
        exact ⟨φ.symm y, by simp [hy]⟩
      have hfin_pre : (φ ⁻¹' s)ᶜ.Finite := h1 hpre_nonempty
      have heq : sᶜ = φ '' (φ ⁻¹' s)ᶜ := by
        ext y
        constructor
        · intro hy
          exact ⟨φ.symm y, by simpa using hy, by simp⟩
        · rintro ⟨x, hx, rfl⟩ hy
          exact hx (by simpa using hy)
      rw [heq]
      exact hfin_pre.image _
    · intro h2 hpre_nonempty
      have hs_nonempty : s.Nonempty := by
        obtain ⟨x, hx⟩ := hpre_nonempty
        exact ⟨φ x, hx⟩
      have hfin_s : sᶜ.Finite := h2 hs_nonempty
      have h_compl : (φ ⁻¹' s)ᶜ = φ ⁻¹' sᶜ := by ext; simp
      rw [h_compl]
      have heq2 : φ ⁻¹' sᶜ = φ.symm '' sᶜ := by
        ext x
        simp only [Set.mem_preimage, Set.mem_image]
        constructor
        · intro hx; exact ⟨φ x, hx, by simp⟩
        · rintro ⟨y, hy, rfl⟩; simpa using hy
      rw [heq2]
      exact hfin_s.image _

end Meta

end PiBase

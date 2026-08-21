module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P225.Defs

@[expose] public section

namespace PiBase

open Topology Set

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.lCSpace : WellDefined LCSpace :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    refine @LCSpace.mk _ _ fun y sY hsY => ?_
    let x := φ.symm y
    have hφx : φ x = y := φ.apply_symm_apply y
    have hsX : φ ⁻¹' sY ∈ 𝓝 x := by
      rw [← Filter.mem_map, φ.map_nhds_eq x, hφx]
      exact hsY
    obtain ⟨tX, htX, fX, hfX_cont, hfX_range, hfX_zero, hfX_one⟩ :=
      h.locally_contractible x (φ ⁻¹' sY) hsX
    have htY : φ.symm ⁻¹' tX ∈ 𝓝 y := by
      exact φ.continuous_symm.continuousAt.preimage_mem_nhds (by simpa [x] using htX)
    let e : (φ.symm ⁻¹' tX) ≃ₜ tX := φ.symm.sets (t := tX) rfl
    let fY : (φ.symm ⁻¹' tX) × unitInterval → _ := fun p => φ (fX (e p.1, p.2))
    have hfY_cont : Continuous fY := by
      exact φ.continuous.comp <|
        hfX_cont.comp <|
          Continuous.prodMk (e.continuous.comp continuous_fst) continuous_snd
    have hfY_range : range fY ⊆ sY := by
      rintro _ ⟨p, rfl⟩
      exact hfX_range ⟨(e p.1, p.2), rfl⟩
    have hfY_zero : ∀ i, fY (i, (0 : unitInterval)) = i.val := by
      intro i
      change φ (fX (e i, (0 : unitInterval))) = i.val
      rw [hfX_zero (e i)]
      exact φ.apply_symm_apply i.val
    have hfY_one : ∀ i, fY (i, (1 : unitInterval)) = y := by
      intro i
      change φ (fX (e i, (1 : unitInterval))) = y
      rw [hfX_one (e i), hφx]
    exact ⟨φ.symm ⁻¹' tX, htY, fY, hfY_cont, hfY_range, hfY_zero, hfY_one⟩

end PiBase

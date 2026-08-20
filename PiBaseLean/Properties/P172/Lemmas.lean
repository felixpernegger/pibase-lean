module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P172.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta


variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.radialSpace : WellDefined RadialSpace :=
  fun {X Y} _ _ hXY h => by
    let φ := hXY.some
    constructor
    intro A x hx
    -- x ∈ closure A in Y, so φ⁻¹ x ∈ closure (φ⁻¹ A) in X because φ is homeomorph
    have hA_pre : φ.symm x ∈ closure (φ ⁻¹' A) := by
      rw [← φ.preimage_closure]
      simpa using hx
    obtain ⟨s, f, hs_pos, hs_range, hs_tend⟩ := h.ex_seq (φ ⁻¹' A) (φ.symm x) hA_pre
    -- transport sequence via φ
    refine ⟨s, fun i => φ (f i), hs_pos, ?_, ?_⟩
    · have : range (fun i => φ (f i)) ⊆ A := by
        intro y hy
        obtain ⟨i, rfl⟩ := hy
        have hi : f i ∈ φ ⁻¹' A := hs_range (mem_range_self i)
        simpa using hi
      exact this
    · have h_comp : Tendsto (fun i => φ (f i)) atTop (𝓝 x) := by
        have h_tend_x : Tendsto f atTop (𝓝 (φ.symm x)) := hs_tend
        have h : Tendsto (φ ∘ f) atTop (𝓝 (φ (φ.symm x))) :=
          (φ.continuous.continuousAt (x := φ.symm x)).tendsto.comp h_tend_x
        simp only [φ.apply_symm_apply] at h
        exact h
      exact h_comp

end Meta

end PiBase

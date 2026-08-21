module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P221.Defs

@[expose] public section

namespace PiBase

open Topology

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.dieudonneCompleteSpace : WellDefined DieudonneCompleteSpace :=
  fun {X Y} _ _ hXY h => by
    let φ := hXY.some
    obtain ⟨uX, huX_top, hCompX⟩ := h.complete_uniformity
    let f : Y → X := φ.symm
    let uY : UniformSpace Y := UniformSpace.comap f uX
    have huY_top : uY.toTopologicalSpace = (inferInstance : TopologicalSpace Y) := by
      have hUniform_top : uX.toTopologicalSpace = (inferInstance : TopologicalSpace X) := huX_top
      calc uY.toTopologicalSpace = TopologicalSpace.induced f uX.toTopologicalSpace := rfl
        _ = TopologicalSpace.induced f (inferInstance : TopologicalSpace X) := by rw [hUniform_top]
        _ = (inferInstance : TopologicalSpace Y) := φ.symm.induced_eq
    have hCompY : CompleteSpace Y := by
      constructor
      intro F hCauchyF
      have hUC : UniformContinuous f := uniformContinuous_comap
      have hCauchyX : Cauchy (Filter.map f F) := hCauchyF.map hUC
      obtain ⟨x, hx_lim⟩ := hCompX.complete hCauchyX
      rw [huX_top] at hx_lim
      have h_nhds_eq : Filter.comap f (𝓝 x) = 𝓝 (φ x) := by
        have h_eq : f (φ x) = x := φ.symm_apply_apply x
        have h_ind : TopologicalSpace.induced f (inferInstance : TopologicalSpace X) =
            (inferInstance : TopologicalSpace Y) := φ.symm.induced_eq
        have hn := nhds_induced f (φ x)
        rw [h_ind, h_eq] at hn
        exact hn.symm
      have h_le : F ≤ Filter.comap f (Filter.map f F) := Filter.le_comap_map
      have h_mono : Filter.comap f (Filter.map f F) ≤ Filter.comap f (𝓝 x) :=
        Filter.comap_mono hx_lim
      have h_final : F ≤ Filter.comap f (𝓝 x) := le_trans h_le h_mono
      rw [h_nhds_eq] at h_final
      exact ⟨φ x, huY_top ▸ h_final⟩
    exact ⟨uY, huY_top, hCompY⟩

end PiBase

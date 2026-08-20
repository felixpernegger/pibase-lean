module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P166.Defs

@[expose] public section

universe u v

namespace PiBase

open Topology Filter Set Function TopologicalSpace

namespace Formal

theorem hasCoarserSeparableMetrizableTopology_of_homeomorph
    {X : Type u} {Y : Type v} [TopologicalSpace X] [TopologicalSpace Y]
    (φ : X ≃ₜ Y) (h : HasCoarserSeparableMetrizableTopology X) :
    HasCoarserSeparableMetrizableTopology Y := by
  obtain ⟨mX, hm_le, hm_sep⟩ := h.ex_coarser_metrizable_separable
  let e : X ≃ Y := φ.toEquiv
  let mY : MetricSpace Y := MetricSpace.induced e.symm e.symm.injective mX
  refine ⟨⟨mY, ?_, ?_⟩⟩
  · have h_ind : mY.toUniformSpace.toTopologicalSpace =
        TopologicalSpace.induced (e.symm : Y → X) mX.toUniformSpace.toTopologicalSpace := rfl
    intro s hs
    rw [h_ind] at hs
    obtain ⟨u, hu, hus⟩ :=
      (isOpen_induced_iff (t := mX.toUniformSpace.toTopologicalSpace) (f := e.symm)).mp hs
    rw [← hus]
    exact (hm_le u hu).preimage φ.symm.continuous
  · let τX : TopologicalSpace X := mX.toUniformSpace.toTopologicalSpace
    let τY : TopologicalSpace Y := mY.toUniformSpace.toTopologicalSpace
    have hτY : τY = TopologicalSpace.induced (e.symm : Y → X) τX := rfl
    have h_cont_symm : @Continuous Y X τY τX (e.symm : Y → X) := by
      rw [hτY]
      exact continuous_induced_dom
    have h_cont : @Continuous X Y τX τY (e : X → Y) := by
      rw [hτY, continuous_induced_rng]
      simpa using (@continuous_id X τX)
    let hY : @Homeomorph X Y τX τY :=
      { toEquiv := e
        continuous_toFun := h_cont
        continuous_invFun := h_cont_symm }
    let : TopologicalSpace X := τX
    let : TopologicalSpace Y := τY
    let : SeparableSpace X := hm_sep
    exact hY.isQuotientMap.separableSpace

namespace P166

theorem well_defined {X : Type u} {Y : Type v} [TopologicalSpace X] [TopologicalSpace Y]
    (φ : X ≃ₜ Y) (h : HasCoarserSeparableMetrizableTopology X) :
    HasCoarserSeparableMetrizableTopology Y :=
  hasCoarserSeparableMetrizableTopology_of_homeomorph φ h

end P166

end Formal

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.hasCoarserSeparableMetrizableTopology :
    WellDefined HasCoarserSeparableMetrizableTopology :=
  fun {_ _} _ _ hXY hX =>
    Formal.hasCoarserSeparableMetrizableTopology_of_homeomorph hXY.some hX

end Meta

end PiBase

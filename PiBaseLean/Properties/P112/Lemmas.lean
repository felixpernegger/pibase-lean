module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P112.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.submetrizableSpace : WellDefined SubmetrizableSpace :=
  fun {X Y} _ _ hXY h => by
    let φ := hXY.some
    obtain ⟨mX, hm⟩ := h.le_metrizable
    let mY : MetricSpace Y := MetricSpace.induced φ.symm φ.symm.injective mX
    refine ⟨⟨mY, ?_⟩⟩
    have h_ind : mY.toUniformSpace.toTopologicalSpace =
        TopologicalSpace.induced (φ.symm : Y → X) mX.toUniformSpace.toTopologicalSpace := rfl
    intro s hs
    rw [h_ind] at hs
    obtain ⟨u, hu, hus⟩ :=
      (isOpen_induced_iff (t := mX.toUniformSpace.toTopologicalSpace) (f := φ.symm)).mp hs
    rw [← hus]
    exact (hm u hu).preimage φ.symm.continuous

end PiBase

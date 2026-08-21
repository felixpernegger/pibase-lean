module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P220.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.ultraMetrizableSpace : WellDefined UltraMetrizableSpace :=
  fun {X Y} _ _ hXY h => by
    let φ := hXY.some
    obtain ⟨mX, hUltraX, hTopX⟩ := h.ex_ultrametric
    -- Pull the ultrametric back along the injection `φ.symm : Y → X`.
    let mY : MetricSpace Y := MetricSpace.induced φ.symm φ.symm.injective mX
    have hUltraY : @IsUltrametricDist Y mY.toDist :=
      ⟨fun y₁ y₂ y₃ => hUltraX.dist_triangle_max (φ.symm y₁) (φ.symm y₂) (φ.symm y₃)⟩
    have hTopY : mY.toUniformSpace.toTopologicalSpace = (inferInstance : TopologicalSpace Y) := by
      have hcomap : mY.toUniformSpace.toTopologicalSpace =
          TopologicalSpace.induced φ.symm mX.toUniformSpace.toTopologicalSpace := rfl
      rw [hcomap, hTopX]
      exact φ.symm.induced_eq
    exact ⟨mY, hUltraY, hTopY⟩

end PiBase

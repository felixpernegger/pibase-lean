module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P191.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.hasGδSingletons : WellDefined HasGδSingletons :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    refine ⟨fun x ↦ ?_⟩
    convert IsGδ.preimage φ.symm.continuous (@h.isGδ_singleton (φ.symm x))
    ext
    simp

end PiBase

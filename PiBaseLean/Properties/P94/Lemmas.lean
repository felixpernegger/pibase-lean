module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P94.Defs

@[expose] public section

namespace PiBase

open Topology

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.locallyFiniteSpace : WellDefined LocallyFiniteSpace :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    refine ⟨fun y => ?_⟩
    rcases h.locally_finite (φ.symm y) with ⟨U, nU, cU⟩
    refine ⟨φ '' U, ?_, cU.image φ⟩
    rw [← φ.apply_symm_apply y, ← φ.map_nhds_eq (φ.symm y)]
    change φ ⁻¹' (φ '' U) ∈ 𝓝 (φ.symm y)
    simpa

end PiBase

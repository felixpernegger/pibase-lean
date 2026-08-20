module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P86.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta


variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.homogeneousSpace : WellDefined HomogeneousSpace :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    refine ⟨fun x y ↦ ?_⟩
    rcases h.homogeneous (φ.symm x) (φ.symm y) with ⟨e, ex⟩
    refine ⟨(φ.symm.trans e).trans φ, ?_⟩
    simp only [ex, Homeomorph.trans_apply, Homeomorph.apply_symm_apply]

end Meta

end PiBase

module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P87.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta


variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.hasGroupTopology : WellDefined HasGroupTopology :=
  fun {_ Y} _ _ hXY h => by
    let φ := hXY.some
    rcases h with ⟨G, h⟩
    let H := φ.symm.toEquiv.group
    refine ⟨H, @IsTopologicalGroup.mk Y _ H
      ⟨(?_ : Continuous fun (p : Y × Y) ↦ φ (φ.symm p.1 * φ.symm p.2))⟩
      ⟨(?_ : Continuous fun p ↦ φ (φ.symm p)⁻¹)⟩⟩ <;> fun_prop

end Meta

end PiBase

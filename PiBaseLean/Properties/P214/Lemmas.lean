module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P214.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.α4Space : WellDefined α4Space :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    constructor
    intro y S S_inj hS
    obtain ⟨T, hT_inj, hT_tend, hT_sub, hT_infSet⟩ :=
      h.subset_converge (x := φ.symm y) (S := fun n => φ.symm ∘ S n)
        (fun n => φ.symm.injective.comp (S_inj n))
        (fun n => AlphaTransport.tendsto_symm_comp φ (hS n))
    exact ⟨φ ∘ T, φ.injective.comp hT_inj, AlphaTransport.tendsto_comp_of_symm φ hT_tend,
      AlphaTransport.range_comp_subset φ S T hT_sub,
      AlphaTransport.infinite_setOf_nonempty_inter φ S T hT_infSet⟩

end Meta

end PiBase

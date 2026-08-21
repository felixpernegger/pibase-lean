module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P211.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.α15Space : WellDefined α15Space :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    constructor
    intro y S S_inj S_disj hS
    obtain ⟨T, hT_inj, hT_tend, hT_sub, hT_inf⟩ :=
      h.subset_converge (x := φ.symm y) (S := fun n => φ.symm ∘ S n)
        (fun n => φ.symm.injective.comp (S_inj n))
        (AlphaTransport.symm_pairwise_disjoint φ S S_disj)
        (fun n => AlphaTransport.tendsto_symm_comp φ (hS n))
    exact ⟨φ ∘ T, φ.injective.comp hT_inj, AlphaTransport.tendsto_comp_of_symm φ hT_tend,
      AlphaTransport.range_comp_subset φ S T hT_sub,
      AlphaTransport.infinite_setOf_finite_diff φ S T hT_inf⟩

end PiBase

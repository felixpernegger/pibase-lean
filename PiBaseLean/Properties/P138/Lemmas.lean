module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P138.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta


variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.countablyManyContinuousSelfMaps : WellDefined CountablyManyContinuousSelfMaps :=
  fun {X Y} _ _ hXY h => by
    let φ := hXY.some
    constructor
    -- Homeomorphs as bundled continuous maps
    let φc : C(X, Y) := ⟨φ, φ.continuous⟩
    let ψc : C(Y, X) := ⟨φ.symm, φ.symm.continuous⟩
    -- Conjugation equivalence C(X,X) ≃ C(Y,Y) : f ↦ φ ∘ f ∘ φ.symm
    -- using ContinuousMap.comp for bundled continuity
    let e : C(X, X) ≃ C(Y, Y) := {
      toFun := fun f => φc.comp (f.comp ψc)
      invFun := fun g => ψc.comp (g.comp φc)
      left_inv := by
        intro f
        ext x
        simp only [φc, ψc, ContinuousMap.coe_mk, ContinuousMap.comp_apply,
          Homeomorph.symm_apply_apply]
      right_inv := by
        intro g
        ext y
        simp only [φc, ψc, ContinuousMap.coe_mk, ContinuousMap.comp_apply,
          Homeomorph.apply_symm_apply]
    }
    -- transport Countable via the equivalence
    exact (Equiv.countable_iff e).mp h.countable_self_maps

end Meta

end PiBase

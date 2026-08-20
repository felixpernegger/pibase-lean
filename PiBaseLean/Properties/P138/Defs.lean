module

public import Mathlib.Topology.ContinuousMap.Basic
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function TopologicalSpace

universe u

namespace PiBase

/- 138. Countably many continuous self-maps -/
class CountablyManyContinuousSelfMaps (X : Type u) [TopologicalSpace X] : Prop where
  countable_self_maps : Countable C(X, X)

end PiBase

namespace PiBase.Formal

def P138 : Property where
  toPred := CountablyManyContinuousSelfMaps
  well_defined {X Y} _ _ φ h := by
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

end PiBase.Formal

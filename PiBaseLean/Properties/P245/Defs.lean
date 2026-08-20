module

public import Mathlib.Data.Finite.Defs
public import Mathlib.Topology.Defs.Basic
public import PiBaseLean.Properties.Bundled.Defs
public import Mathlib.Topology.Sets.Opens

@[expose] public section

universe u

open TopologicalSpace Set

namespace PiBase

/- 245. Has finitely many open sets -/
class HasFinitelyManyOpenSets (X : Type u) [t : TopologicalSpace X] : Prop where
  finite_open_sets : Finite (Opens X)

end PiBase

namespace PiBase.Formal

def P245 : Property where
  toPred := HasFinitelyManyOpenSets
  well_defined {X Y} _ _ φ h := by
    have : Finite (Opens X) := h.finite_open_sets
    have e : Opens X ≃ Opens Y :=
      { toFun := fun U => ⟨φ '' (U : Set X), by rw [φ.isOpen_image]; exact U.isOpen⟩
        invFun := fun V => ⟨φ.symm '' (V : Set Y), by rw [φ.symm.isOpen_image]; exact V.isOpen⟩
        left_inv := fun U => by
          apply TopologicalSpace.Opens.ext
          ext x
          simp
        right_inv := fun V => by
          apply TopologicalSpace.Opens.ext
          ext y
          simp
      }
    exact ⟨Finite.of_equiv (Opens X) e⟩

end PiBase.Formal

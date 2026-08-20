module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P245.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.hasFinitelyManyOpenSets [HasFinitelyManyOpenSets X] (f : X ≃ₜ Y) :
    HasFinitelyManyOpenSets Y := by
  have : Finite (Opens X) := (inferInstance : HasFinitelyManyOpenSets X).finite_open_sets
  have e : Opens X ≃ Opens Y :=
    { toFun := fun U => ⟨f '' (U : Set X), by rw [f.isOpen_image]; exact U.isOpen⟩
      invFun := fun V => ⟨f.symm '' (V : Set Y), by rw [f.symm.isOpen_image]; exact V.isOpen⟩
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

theorem WellDefined.hasFinitelyManyOpenSets : WellDefined HasFinitelyManyOpenSets :=
  fun {_ _} _ _ h _ => Homeomorph.hasFinitelyManyOpenSets h.some

end Meta

end PiBase

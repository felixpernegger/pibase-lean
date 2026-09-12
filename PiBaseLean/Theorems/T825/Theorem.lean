module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P226.Bundled
public import PiBaseLean.Properties.P245.Bundled

@[expose] public section

universe u

open TopologicalSpace

namespace PiBase

/-- Theorem T825: P245 (HasFinitelyManyOpenSets) => P226 (ArtinianSpace)

Complementation injects the closed sets into the open sets, so there are finitely many of
those too, and a finite order is well-founded. -/
theorem instArtinianSpaceOfHasFinitelyManyOpenSets {X : Type u}
    [TopologicalSpace X] [h : HasFinitelyManyOpenSets X] : ArtinianSpace X := by
  have := h.finite_open_sets
  have : Finite (Closeds X) :=
    Finite.of_injective
      (fun C : Closeds X ↦ (⟨(C : Set X)ᶜ, C.isClosed.isOpen_compl⟩ : Opens X))
      (fun _ _ hab ↦
        Closeds.ext (compl_injective (congrArg (fun U : Opens X ↦ (U : Set X)) hab)))
  exact Finite.to_wellFoundedGT

end PiBase

namespace PiBase.Formal

theorem T825 : P245 ≤ P226 := fun X _ h ↦ @instArtinianSpaceOfHasFinitelyManyOpenSets X _ h

end PiBase.Formal

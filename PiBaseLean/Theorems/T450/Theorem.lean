module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P245.Bundled
public import PiBaseLean.Properties.P27.Bundled

@[expose] public section

universe u

open Set TopologicalSpace

namespace PiBase

/-- Theorem T450: P245 (HasFinitelyManyOpenSets) => P27 (SecondCountableTopology)

The topology is finite, hence countable, so it is itself a countable basis. -/
theorem instSecondCountableTopologyOfHasFinitelyManyOpenSets {X : Type u}
    [TopologicalSpace X] [h : HasFinitelyManyOpenSets X] : SecondCountableTopology X := by
  have := h.finite_open_sets
  refine isTopologicalBasis_opens.secondCountableTopology ?_
  have : Finite {U : Set X | IsOpen U} :=
    Finite.of_injective (fun U : {U : Set X | IsOpen U} ↦ (⟨U.1, U.2⟩ : Opens X))
      (fun _ _ h ↦ Subtype.ext (congrArg (fun V : Opens X ↦ (V : Set X)) h))
  exact Set.countable_coe_iff.1 Finite.to_countable

end PiBase

namespace PiBase.Formal

theorem T450 : P245 ≤ P27 := fun X _ h ↦ @instSecondCountableTopologyOfHasFinitelyManyOpenSets X _ h

end PiBase.Formal

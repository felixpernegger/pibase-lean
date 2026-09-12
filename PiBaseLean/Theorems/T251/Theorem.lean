module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P129.Bundled
public import PiBaseLean.Properties.P245.Bundled

@[expose] public section

universe u

open Set TopologicalSpace

namespace PiBase

/-- Theorem T251: P129 (IndiscreteTopology) => P245 (HasFinitelyManyOpenSets)

An indiscrete space has only `∅` and `univ` open, so an open set is determined by
whether it is `univ`. -/
theorem instHasFinitelyManyOpenSetsOfIndiscreteTopology {X : Type u}
    [TopologicalSpace X] [IndiscreteTopology X] : HasFinitelyManyOpenSets X := by
  refine ⟨Finite.of_injective (fun U : Opens X ↦ (U : Set X) = univ) ?_⟩
  intro U V h
  have hU := U.isOpen
  have hV := V.isOpen
  rw [IndiscreteTopology.isOpen_iff] at hU hV
  apply Opens.ext
  rcases hU with hU | hU <;> rcases hV with hV | hV <;> simp_all

end PiBase

namespace PiBase.Formal

theorem T251 : P129 ≤ P245 := fun X _ h ↦ @instHasFinitelyManyOpenSetsOfIndiscreteTopology X _ h

end PiBase.Formal

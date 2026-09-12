module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P208.Bundled
public import PiBaseLean.Properties.P245.Bundled

@[expose] public section

universe u

open TopologicalSpace

namespace PiBase

/-- Theorem T198: P245 (HasFinitelyManyOpenSets) => P208 (NoetherianSpace) -/
theorem instNoetherianSpaceOfHasFinitelyManyOpenSets {X : Type u}
    [TopologicalSpace X] [h : HasFinitelyManyOpenSets X] : NoetherianSpace X :=
  have := h.finite_open_sets
  ⟨Finite.to_wellFoundedGT.wf⟩

end PiBase

namespace PiBase.Formal

theorem T198 : P245 ≤ P208 := fun X _ h ↦ @instNoetherianSpaceOfHasFinitelyManyOpenSets X _ h

end PiBase.Formal

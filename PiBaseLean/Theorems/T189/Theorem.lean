module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P245.Bundled
public import PiBaseLean.Properties.P78.Bundled

import Mathlib.Data.SetLike.Fintype

@[expose] public section

universe u

open TopologicalSpace

namespace PiBase

/-- Theorem T189: P78 (Finite) => P245 (HasFinitelyManyOpenSets) -/
theorem instHasFinitelyManyOpenSetsOfFinite {X : Type u}
    [TopologicalSpace X] [Finite X] : HasFinitelyManyOpenSets X :=
  ⟨inferInstance⟩

end PiBase

namespace PiBase.Formal

theorem T189 : P78 ≤ P245 := fun X _ h ↦ @instHasFinitelyManyOpenSetsOfFinite X _ h

end PiBase.Formal

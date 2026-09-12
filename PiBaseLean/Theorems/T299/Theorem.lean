module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P78.Bundled
public import PiBaseLean.Properties.P138.Bundled

@[expose] public section

universe u

open Set

namespace PiBase

variable {X : Type u} [TopologicalSpace X]

/-- Theorem T299: P78 ≤ P138

There are only finitely many functions `X → X` when `X` is finite, and `C(X, X)` injects into
them. -/
theorem instCountablyManyContinuousSelfMapsOfFinite [Finite X] :
    CountablyManyContinuousSelfMaps X :=
  ⟨have : Finite C(X, X) := Finite.of_injective _ (DFunLike.coe_injective (F := C(X, X)))
   Finite.to_countable⟩

end PiBase

namespace PiBase.Formal

theorem T299 : P78 ≤ P138 := fun X _ h ↦ @instCountablyManyContinuousSelfMapsOfFinite X _ h

end PiBase.Formal

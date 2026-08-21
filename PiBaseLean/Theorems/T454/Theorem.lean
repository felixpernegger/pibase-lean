module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P181.Bundled
public import PiBaseLean.Properties.P57.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem 454: Countably infinite implies countable -/
theorem instCountableOfCountablyInfiniteOfCountablyInfinite {X : Type u} [CountablyInfinite X] :
    Countable X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T454 : P181 ≤ P57 := fun X _ ↦ @instCountableOfCountablyInfiniteOfCountablyInfinite X

end PiBase.Formal

import PiBaseLean.Properties.P181.Defs

universe u

namespace PiBase

/-- Theorem 454: Countably infinite implies countable -/
theorem instCountableOfCountablyInfiniteOfCountablyInfinite {X : Type u} [CountablyInfinite X] :
    Countable X := by infer_instance

end PiBase

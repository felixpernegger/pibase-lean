import Mathlib.Data.Fintype.EquivFin
import PiBaseLean.Properties.P181.Defs

universe u

namespace PiBase

--TODO: When negations of properties are properly implemented, maybe redo this
/-- Theorem 456: a countable, infinite space is countably infinite -/
theorem instInfiniteOfCountableInfinite {X : Type u} [CountablyInfinite X] : Infinite X := by
  infer_instance

end PiBase

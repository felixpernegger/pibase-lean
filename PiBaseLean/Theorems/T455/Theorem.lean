module

public import Mathlib.Data.Fintype.EquivFin
public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P78.Defs
public import PiBaseLean.Properties.P181.Defs

@[expose] public section

universe u

namespace PiBase

--TODO: When negations of properties are properly implemented, maybe redo this
/-- Theorem 455: a countable, infinite space is countably infinite -/
theorem instInfiniteOfCountableInfinite {X : Type u} [CountablyInfinite X] : Infinite X := by
  infer_instance

end PiBase

namespace PiBase.Formal

theorem T455 : P181 ≤ P78ᶜ := fun X _ h ↦ (@instInfiniteOfCountableInfinite X h).1

end PiBase.Formal

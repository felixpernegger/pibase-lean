module

public import Mathlib.Data.Fintype.EquivFin
public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P78.Bundled
public import PiBaseLean.Properties.P181.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem 455: a countable, infinite space is countably infinite -/
theorem instInfiniteOfCountableInfinite {X : Type u} [CountablyInfinite X] : Infinite X :=
  inferInstance

end PiBase

namespace PiBase.Formal

theorem T455 : P181 ≤ P78ᶜ :=
  fun X _ h ↦ (@instInfiniteOfCountableInfinite X h).1

end PiBase.Formal

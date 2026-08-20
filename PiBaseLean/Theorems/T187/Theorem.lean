module

public import Mathlib.Data.Countable.Defs
public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P57.Bundled
public import PiBaseLean.Properties.P78.Bundled

@[expose] public section

namespace PiBase

/- Theorem 187: a finite space is countable -/
#check Finite.to_countable

end PiBase

namespace PiBase.Formal

theorem T187 : P78 ≤ P57 := fun X _ ↦ @Finite.to_countable X

end PiBase.Formal

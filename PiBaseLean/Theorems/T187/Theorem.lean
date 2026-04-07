import Mathlib.Data.Countable.Defs
import PiBaseLean.Properties.Bundled.Basic
import PiBaseLean.Properties.P57.Defs
import PiBaseLean.Properties.P78.Defs

namespace PiBase

/- Theorem 187: a finite space is countable -/
#check Finite.to_countable

end PiBase

namespace PiBase.Formal

theorem T187 : P78 ≤ P57 := fun X _ ↦ @Finite.to_countable X

end PiBase.Formal

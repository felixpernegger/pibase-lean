import Mathlib.Logic.Nontrivial.Defs
import PiBaseLean.Properties.Bundled.Basic
import PiBaseLean.Properties.P125.Defs
import PiBaseLean.Properties.P137.Defs

namespace PiBase

--TODO: When negations of properties are properly implemented, maybe redo this
/- Theorem 295: a space with multiple points is nonempty -/
#check Nontrivial.to_nonempty

end PiBase

namespace PiBase.Formal

theorem T295 : P125 ≤ P137ᶜ := fun X _ h ↦ not_isEmpty_iff.2 (@Nontrivial.to_nonempty X h)

end PiBase.Formal

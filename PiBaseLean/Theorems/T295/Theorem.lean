module

public import Mathlib.Logic.Nontrivial.Defs
public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P125.Defs
public import PiBaseLean.Properties.P137.Defs

@[expose] public section

namespace PiBase

--TODO: When negations of properties are properly implemented, maybe redo this
/- Theorem 295: a space with multiple points is nonempty -/
#check Nontrivial.to_nonempty

end PiBase

namespace PiBase.Formal

theorem T295 : P125 ≤ P137ᶜ := fun X _ h ↦ not_isEmpty_iff.2 (@Nontrivial.to_nonempty X h)

end PiBase.Formal

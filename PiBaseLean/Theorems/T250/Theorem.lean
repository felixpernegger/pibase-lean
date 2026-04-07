module

public import Mathlib.Data.Fintype.EquivFin
public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P78.Defs
public import PiBaseLean.Properties.P125.Defs

@[expose] public section

namespace PiBase

--TODO: When negations of properties are properly implemented, maybe redo this
/- Theorem 250: an infinite space has multiple points  -/
#check Infinite.instNontrivial

end PiBase

namespace PiBase.Formal

theorem T250 : P78ᶜ ≤ P125 := fun X _ h ↦ @Infinite.instNontrivial X (.mk h)

end PiBase.Formal

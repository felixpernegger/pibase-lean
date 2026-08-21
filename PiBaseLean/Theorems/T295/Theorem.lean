module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P125.Bundled
public import PiBaseLean.Properties.P137.Bundled

@[expose] public section

namespace PiBase

/- Theorem 295: a space with multiple points is nonempty -/
#guard_msgs (drop info) in
#check Nontrivial.to_nonempty

end PiBase

namespace PiBase.Formal

theorem T295 : P125 ≤ P137ᶜ := fun X _ h ↦ not_isEmpty_iff.2 (@Nontrivial.to_nonempty X h)

end PiBase.Formal

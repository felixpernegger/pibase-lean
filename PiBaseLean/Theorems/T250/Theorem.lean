module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P125.Bundled
public import PiBaseLean.Properties.P78.Bundled

@[expose] public section

namespace PiBase

/- Theorem 250: an infinite space has multiple points  -/
#guard_msgs (drop info) in
#check Infinite.instNontrivial

end PiBase

namespace PiBase.Formal

theorem T250 : P78ᶜ ≤ P125 := fun X _ h ↦ @Infinite.instNontrivial X (.mk h)

end PiBase.Formal

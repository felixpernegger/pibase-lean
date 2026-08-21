module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P47.Bundled
public import PiBaseLean.Properties.P48.Bundled

@[expose] public section

universe u

namespace PiBase

/- Theorem T46: P48 (TotallySeparatedSpace) => P47 (TotallyDisconnectedSpace) -/
#guard_msgs (drop info) in
#check TotallySeparatedSpace.totallyDisconnectedSpace

end PiBase

namespace PiBase.Formal

theorem T46 : P48 ≤ P47 := fun X _ _ ↦ by
  simp_all only [P48, P47]
  infer_instance

end PiBase.Formal

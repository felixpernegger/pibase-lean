module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P47.Bundled
public import PiBaseLean.Properties.P48.Bundled

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/- Theorem T46: P48 (TotallySeparatedSpace) => P47 (TotallyDisconnectedSpace) -/
#check TotallySeparatedSpace.totallyDisconnectedSpace

end PiBase

namespace PiBase.Formal

theorem T46 : P48 ≤ P47 := fun X _ _ ↦ by
  simp_all only [P48, P47]
  infer_instance

end PiBase.Formal

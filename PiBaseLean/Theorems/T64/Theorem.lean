module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P41.Bundled
public import PiBaseLean.Properties.P42.Bundled

@[expose] public section

universe u

namespace PiBase

/- Theorem T64: P42 (LocallyPathConnectedSpace) => P41 (LocallyConnectedSpace) -/
#guard_msgs (drop info) in
#check instLocallyConnectedSpace

end PiBase

namespace PiBase.Formal

theorem T64 : P42 ≤ P41 := fun X _ _ ↦ by
  simp_all only [P42, P41]
  infer_instance

end PiBase.Formal

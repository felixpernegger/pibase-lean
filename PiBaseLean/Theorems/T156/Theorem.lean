module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P14.Bundled
public import PiBaseLean.Properties.P15.Bundled

@[expose] public section

universe u

namespace PiBase

/- Theorem T156: P15 (PerfectlyNormalSpace) => P14 (CompletelyNormalSpace) -/
#guard_msgs (drop info) in
#check PerfectlyNormalSpace.toCompletelyNormalSpace

end PiBase

namespace PiBase.Formal

theorem T156 : P15 ≤ P14 := fun X _ _ ↦ by
  simp_all only [P15, P14]
  infer_instance

end PiBase.Formal

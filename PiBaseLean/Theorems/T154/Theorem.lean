module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P67.Bundled
public import PiBaseLean.Properties.P8.Bundled

@[expose] public section

universe u

namespace PiBase

/- Theorem T154: P67 (T6Space) => P8 (T5Space) -/
#guard_msgs (drop info) in
#check T6Space.toT5Space

end PiBase

namespace PiBase.Formal

theorem T154 : P67 ≤ P8 := fun X _ _ ↦ by
  simp_all only [P67, P8]
  infer_instance

end PiBase.Formal

module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P17.Bundled
public import PiBaseLean.Properties.P18.Bundled

@[expose] public section

universe u

namespace PiBase

/- Theorem T122: P17 (SigmaCompactSpace) => P18 (LindelofSpace) -/
#guard_msgs (drop info) in
#check instLindelofSpaceOfSigmaCompactSpace

end PiBase

namespace PiBase.Formal

theorem T122 : P17 ≤ P18 := fun X _ _ ↦ by
  simp_all only [P17, P18]
  infer_instance

end PiBase.Formal

module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P17.Bundled
public import PiBaseLean.Properties.P18.Bundled

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/- Theorem T122: P17 (SigmaCompactSpace) => P18 (LindelofSpace) -/
#check instLindelofSpaceOfSigmaCompactSpace

end PiBase

namespace PiBase.Formal

theorem T122 : P17 ≤ P18 := fun X _ _ ↦ by
  simp_all only [P17, P18]
  infer_instance

end PiBase.Formal

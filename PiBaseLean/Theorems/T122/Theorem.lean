module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P17.Defs
public import PiBaseLean.Properties.P18.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/- Theorem T122: P17 (SigmaCompactSpace) => P18 (LindelofSpace) -/
#check _root_.instLindelofSpaceOfSigmaCompactSpace

end PiBase

namespace PiBase.Formal

theorem T122 : P17 ≤ P18 := fun X _ _ ↦ by
  simp_all only [P17, P18]
  infer_instance

end PiBase.Formal

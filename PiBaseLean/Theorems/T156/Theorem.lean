module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P14.Defs
public import PiBaseLean.Properties.P15.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/- Theorem T156: P15 (PerfectlyNormalSpace) => P14 (CompletelyNormalSpace) -/
#check PerfectlyNormalSpace.toCompletelyNormalSpace

end PiBase

namespace PiBase.Formal

theorem T156 : P15 ≤ P14 := fun X _ _ ↦ by
  simp_all only [P15, P14]
  infer_instance

end PiBase.Formal

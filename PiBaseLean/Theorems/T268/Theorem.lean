module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P121.Bundled
public import PiBaseLean.Properties.P15.Bundled

import Mathlib.Topology.GDelta.MetrizableSpace

@[expose] public section

universe u

namespace PiBase

/- Theorem T268: P121 (PseudoMetrizableSpace) => P15 (PerfectlyNormalSpace) -/
#guard_msgs (drop info) in
#check _root_.instPerfectlyNormalSpaceOfPseudoMetrizableSpace

end PiBase

namespace PiBase.Formal

theorem T268 : P121 ≤ P15 := fun X _ _ ↦ by
  simp_all only [P121, P15]
  infer_instance

end PiBase.Formal

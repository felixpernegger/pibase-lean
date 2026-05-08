module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P15.Defs
public import PiBaseLean.Properties.P121.Defs
public import Mathlib.Topology.GDelta.MetrizableSpace

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/- Theorem T268: P121 (PseudoMetrizableSpace) => P15 (PerfectlyNormalSpace) -/
#check _root_.instPerfectlyNormalSpaceOfPseudoMetrizableSpace

end PiBase

namespace PiBase.Formal

theorem T268 : P121 ≤ P15 := fun X _ _ ↦ by
  simp_all only [P121, P15]
  infer_instance

end PiBase.Formal

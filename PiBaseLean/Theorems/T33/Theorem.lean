module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P4.Defs
public import PiBaseLean.Properties.P5.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/- Theorem T33: P5 (T3Space) => P4 (T25Space) -/
#check T3Space.t25Space

end PiBase

namespace PiBase.Formal

theorem T33 : P5 ≤ P4 := fun X _ _ ↦ by
  simp_all only [P5, P4]
  infer_instance

end PiBase.Formal

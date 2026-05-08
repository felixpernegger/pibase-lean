module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P8.Defs
public import PiBaseLean.Properties.P67.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/- Theorem T154: P67 (T6Space) => P8 (T5Space) -/
#check T6Space.toT5Space

end PiBase

namespace PiBase.Formal

theorem T154 : P67 ≤ P8 := fun X _ _ ↦ by
  simp_all only [P67, P8]
  infer_instance

end PiBase.Formal

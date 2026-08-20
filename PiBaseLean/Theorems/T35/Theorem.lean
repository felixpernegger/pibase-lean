module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P11.Bundled
public import PiBaseLean.Properties.P12.Bundled

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/- Theorem T35: P12 (CompletelyRegularSpace) => P11 (RegularSpace) -/
#check CompletelyRegularSpace.instRegularSpace

end PiBase

namespace PiBase.Formal

theorem T35 : P12 ≤ P11 := fun X _ _ ↦ by
  simp_all only [P12, P11]
  infer_instance

end PiBase.Formal

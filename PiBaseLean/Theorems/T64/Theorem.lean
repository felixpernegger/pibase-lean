module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P41.Defs
public import PiBaseLean.Properties.P42.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/- Theorem T64: P42 (LocPathConnectedSpace) => P41 (LocallyConnectedSpace) -/
#check instLocallyConnectedSpace

end PiBase

namespace PiBase.Formal

theorem T64 : P42 ≤ P41 := fun X _ _ ↦ by
  simp_all only [P42, P41]
  infer_instance

end PiBase.Formal

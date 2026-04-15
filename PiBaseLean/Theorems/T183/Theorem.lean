module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P28.Defs
public import PiBaseLean.Properties.P80.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/- Theorem T183: P28 (FirstCountableTopology) => P80 (FrechetUrysohnSpace) -/
#check FirstCountableTopology.frechetUrysohnSpace

end PiBase

namespace PiBase.Formal

theorem T183 : P28 ≤ P80 := fun X _ _ ↦ by
  simp_all only [P28, P80]
  infer_instance

end PiBase.Formal

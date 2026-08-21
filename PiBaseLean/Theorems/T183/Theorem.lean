module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P28.Bundled
public import PiBaseLean.Properties.P80.Bundled

@[expose] public section

universe u

namespace PiBase

/- Theorem T183: P28 (FirstCountableTopology) => P80 (FrechetUrysohnSpace) -/
#guard_msgs (drop info) in
#check FirstCountableTopology.frechetUrysohnSpace

end PiBase

namespace PiBase.Formal

theorem T183 : P28 ≤ P80 := fun X _ _ ↦ by
  simp_all only [P28, P80]
  infer_instance

end PiBase.Formal

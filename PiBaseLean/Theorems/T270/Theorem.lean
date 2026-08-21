module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P27.Bundled
public import PiBaseLean.Properties.P28.Bundled

@[expose] public section

universe u

open TopologicalSpace

namespace PiBase

/- Theorem T270: P27 (SecondCountableTopology) => P28 (FirstCountableTopology) -/
#guard_msgs (drop info) in
#check SecondCountableTopology.to_firstCountableTopology

end PiBase

namespace PiBase.Formal

theorem T270 : P27 ≤ P28 := fun X _ _ ↦ by
  simp_all only [P27, P28]
  infer_instance

end PiBase.Formal

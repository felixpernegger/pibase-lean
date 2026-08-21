module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P53.Bundled
public import PiBaseLean.Properties.P55.Bundled

@[expose] public section

universe u

open TopologicalSpace

namespace PiBase

/- Theorem T77: P55 (IsCompletelyMetrizableSpace) => P53 (MetrizableSpace) -/
#guard_msgs (drop info) in
#check PseudoMetrizableSpace.toMetrizableSpace

end PiBase

namespace PiBase.Formal

theorem T77 : P55 ≤ P53 := fun X _ _ ↦ by
  simp_all only [P55, P53]
  infer_instance

end PiBase.Formal

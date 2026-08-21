module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P1.Bundled
public import PiBaseLean.Properties.P121.Bundled
public import PiBaseLean.Properties.P53.Bundled

@[expose] public section

universe u

open TopologicalSpace

namespace PiBase

/- Theorem T265: P121 (PseudoMetrizableSpace) + P1 (T0Space) => P53 (MetrizableSpace) -/
#guard_msgs (drop info) in
#check PseudoMetrizableSpace.toMetrizableSpace

end PiBase

namespace PiBase.Formal

theorem T265 : P121 ⊓ P1 ≤ P53 := fun X _ ⟨_, _⟩ ↦ by
  simp_all only [P121, P1, P53]
  infer_instance

end PiBase.Formal

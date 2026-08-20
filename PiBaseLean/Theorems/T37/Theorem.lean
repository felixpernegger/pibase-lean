module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P12.Bundled
public import PiBaseLean.Properties.P13.Bundled
public import PiBaseLean.Properties.P135.Bundled

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/- Theorem T37: P13 (NormalSpace) + P135 (R0Space) => P12 (CompletelyRegularSpace) -/
#check NormalSpace.instCompletelyRegularSpace

end PiBase

namespace PiBase.Formal

theorem T37 : P13 ⊓ P135 ≤ P12 := fun X _ ⟨_, _⟩ ↦ by
  simp_all only [P13, P135, P12]
  infer_instance

end PiBase.Formal

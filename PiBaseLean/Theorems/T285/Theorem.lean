module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P28.Bundled
public import PiBaseLean.Properties.P90.Bundled

@[expose] public section

universe u

open Topology Set Function

namespace PiBase.Formal

/-- Theorem T285: P90 (AlexandrovDiscrete) => P28 (FirstCountableTopology) -/
theorem T285 : P90 ≤ P28 := fun X _ _ ↦ by
  simp_all only [P90, P28]
  infer_instance

end PiBase.Formal

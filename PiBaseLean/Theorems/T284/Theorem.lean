module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P23.Defs
public import PiBaseLean.Properties.P90.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase.Formal

/-- Theorem T284: P90 (AlexandrovDiscrete) => P23 (WeaklyLocallyCompactSpace) -/
theorem T284 : P90 ≤ P23 := fun X _ _ ↦ by
  simp_all only [P90, P23]
  infer_instance

end PiBase.Formal

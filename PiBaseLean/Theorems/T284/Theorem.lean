module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P23.Bundled
public import PiBaseLean.Properties.P90.Bundled

@[expose] public section

universe u

namespace PiBase.Formal

/-- Theorem T284: P90 (AlexandrovDiscrete) => P23 (WeaklyLocallyCompactSpace) -/
theorem T284 : P90 ≤ P23 := fun X _ _ ↦ by
  simp_all only [P90, P23]
  infer_instance

end PiBase.Formal

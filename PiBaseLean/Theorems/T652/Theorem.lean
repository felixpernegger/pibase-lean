module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P130.Defs
public import PiBaseLean.Properties.P208.Defs
public import Mathlib.Topology.Spectral.Prespectral

@[expose] public section

universe u

open Topology Set Function TopologicalSpace

namespace PiBase

/-- Theorem T652: P208 (NoetherianSpace) => P130 (LocallyCompactSpace) -/
theorem instLocallyCompactSpaceOfNoetherianSpace (X : Type u)
    [TopologicalSpace X] [NoetherianSpace X] : LocallyCompactSpace X := by
  infer_instance

end PiBase

namespace PiBase.Formal

theorem T652 : P208 ≤ P130 := fun X _ _ ↦ by
  simp_all only [P208, P130]
  infer_instance

end PiBase.Formal

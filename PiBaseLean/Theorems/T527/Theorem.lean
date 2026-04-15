module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P75.Defs
public import PiBaseLean.Properties.P130.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T527: P75 (SpectralSpace) => P130 (LocallyCompactSpace) -/
theorem instLocallyCompactSpaceOfSpectralSpace (X : Type u)
    [TopologicalSpace X] [SpectralSpace X] : LocallyCompactSpace X :=
  instLocallyCompactSpaceOfPrespectralSpace

end PiBase

namespace PiBase.Formal

theorem T527 : P75 ≤ P130 := fun X _ ↦ @instLocallyCompactSpaceOfSpectralSpace X _

end PiBase.Formal

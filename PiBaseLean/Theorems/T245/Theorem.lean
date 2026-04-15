module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P23.Defs
public import PiBaseLean.Properties.P130.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T245: P130 (LocallyCompactSpace) => P23 (WeaklyLocallyCompactSpace) -/
theorem instWeaklyLocallyCompactSpaceOfLocallyCompactSpace (X : Type u)
    [TopologicalSpace X] [LocallyCompactSpace X] : WeaklyLocallyCompactSpace X := by
  infer_instance

end PiBase

namespace PiBase.Formal

theorem T245 : P130 ≤ P23 := fun X _ _ ↦ by
  simp_all only [P130, P23]
  infer_instance

end PiBase.Formal

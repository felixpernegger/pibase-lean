module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P78.Defs
public import PiBaseLean.Properties.P208.Defs
public import Mathlib.Topology.NoetherianSpace

@[expose] public section

universe u

open Topology Set Function TopologicalSpace

namespace PiBase

/-- Theorem T198: P78 (Finite) => P208 (NoetherianSpace) -/
theorem instNoetherianSpaceOfFinite (X : Type u)
    [TopologicalSpace X] [Finite X] : NoetherianSpace X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T198 : P78 ≤ P208 := fun X _ _ ↦ by
  simp_all only [P78, P208]
  infer_instance

end PiBase.Formal

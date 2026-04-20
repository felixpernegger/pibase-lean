module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P27.Defs
public import PiBaseLean.Properties.P78.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T189: P78 (Finite) => P27 (SecondCountableTopology) -/
theorem instSecondCountableTopologyOfFinite (X : Type u)
    [TopologicalSpace X] [Finite X] : SecondCountableTopology X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T189 : P78 ≤ P27 := fun X _ _ ↦ by
  simp_all only [P78, P27]
  infer_instance

end PiBase.Formal

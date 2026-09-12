module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P237.Bundled
public import PiBaseLean.Properties.P27.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T340: P237 (TopologicalNManifoldWithBoundary) => P27 (SecondCountableTopology) -/
theorem instSecondCountableTopologyOfTopologicalNManifoldWithBoundary {X : Type u}
    [TopologicalSpace X] [TopologicalNManifoldWithBoundary X] :
    SecondCountableTopology X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T340 : P237 ≤ P27 :=
  fun X _ h ↦ @instSecondCountableTopologyOfTopologicalNManifoldWithBoundary X _ h

end PiBase.Formal

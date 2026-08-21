module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P124.Bundled
public import PiBaseLean.Properties.P27.Bundled

@[expose] public section

universe u

namespace PiBase

-- Most likely redundant
/-- Theorem T340: P124 (TopologicalNManifold) => P27 (SecondCountableTopology) -/
theorem instSecondCountableTopologyOfTopologicalNManifold {X : Type u}
    [TopologicalSpace X] [TopologicalNManifold X] :
    SecondCountableTopology X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T340 : P124 ≤ P27 := fun X _ ↦ @instSecondCountableTopologyOfTopologicalNManifold X _

end PiBase.Formal

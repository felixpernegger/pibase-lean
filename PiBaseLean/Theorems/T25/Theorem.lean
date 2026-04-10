module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P123.Defs
public import PiBaseLean.Properties.P124.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T25: P124 (TopologicalNManifold) => P123 (LocallyNEuclideanSpace) -/
theorem instLocallyNEuclideanSpaceOfTopologicalNManifold (X : Type u)
    [TopologicalSpace X] [TopologicalNManifold X] :
    LocallyNEuclideanSpace X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T25 : P124 ≤ P123 := fun X _ ↦ @instLocallyNEuclideanSpaceOfTopologicalNManifold X _

end PiBase.Formal

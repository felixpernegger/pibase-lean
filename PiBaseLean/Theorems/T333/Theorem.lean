module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P237.Bundled
public import PiBaseLean.Properties.P3.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T333: P237 (TopologicalNManifoldWithBoundary) => P3 (T2Space) -/
theorem instT2SpaceOfTopologicalNManifoldWithBoundary {X : Type u}
    [TopologicalSpace X] [TopologicalNManifoldWithBoundary X] :
    T2Space X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T333 : P237 ≤ P3 := fun X _ h ↦ @instT2SpaceOfTopologicalNManifoldWithBoundary X _ h

end PiBase.Formal

module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P3.Defs
public import PiBaseLean.Properties.P124.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

-- Most likely redundant
/-- Theorem T333: P124 (TopologicalNManifold) => P3 (T2Space) -/
theorem instT2SpaceOfTopologicalNManifold (X : Type u)
    [TopologicalSpace X] [TopologicalNManifold X] :
    T2Space X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T333 : P124 ≤ P3 := fun X _ ↦ @instT2SpaceOfTopologicalNManifold X _

end PiBase.Formal

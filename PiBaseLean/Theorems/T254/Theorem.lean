module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P18.Bundled
public import PiBaseLean.Properties.P131.Bundled

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T254: P131 (HereditarilyLindelofSpace) => P18 (LindelofSpace) -/
theorem instLindelofSpaceOfHereditarilyLindelofSpace (X : Type u)
    [TopologicalSpace X] [HereditarilyLindelofSpace X] :
    LindelofSpace X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T254 : P131 ≤ P18 := fun X _ ↦ @instLindelofSpaceOfHereditarilyLindelofSpace X _

end PiBase.Formal

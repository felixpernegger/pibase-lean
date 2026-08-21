module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P234.Bundled
public import PiBaseLean.Properties.P36.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T864: P36 (PreconnectedSpace) => P234 (HasOpenConnectedComponents) -/
instance instHasOpenConnectedComponentsOfPreconnectedSpace {X : Type u}
    [TopologicalSpace X] [h : PreconnectedSpace X] :
    HasOpenConnectedComponents X where
  component_open x := PreconnectedSpace.connectedComponent_eq_univ x ▸ isOpen_univ

end PiBase

namespace PiBase.Formal

theorem T864 : P36 ≤ P234 := fun X _ ↦ @instHasOpenConnectedComponentsOfPreconnectedSpace X _

end PiBase.Formal

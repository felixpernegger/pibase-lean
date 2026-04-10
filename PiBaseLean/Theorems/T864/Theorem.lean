module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P36.Defs
public import PiBaseLean.Properties.P234.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T864: P36 (PreconnectedSpace) => P234 (HasOpenConnectedComponents) -/
instance instHasOpenConnectedComponentsOfPreconnectedSpace (X : Type u)
    [TopologicalSpace X] [h : PreconnectedSpace X] :
    HasOpenConnectedComponents X where
  component_open x := PreconnectedSpace.connectedComponent_eq_univ x ▸ isOpen_univ

end PiBase

namespace PiBase.Formal

theorem T864 : P36 ≤ P234 := fun X _ ↦ @instHasOpenConnectedComponentsOfPreconnectedSpace X _

end PiBase.Formal

module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P126.Bundled
public import PiBaseLean.Properties.P52.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T144: P52 (DiscreteTopology) => P126 (DoorSpace) -/
instance instDoorSpaceOfDiscreteTopology {X : Type u}
    [TopologicalSpace X] [h : DiscreteTopology X] :
    DoorSpace X where
  isOpen_or_isClosed s := Or.inl <| isOpen_discrete s

end PiBase

namespace PiBase.Formal

theorem T144 : P52 ≤ P126 := fun X _ ↦ @instDoorSpaceOfDiscreteTopology X _

end PiBase.Formal

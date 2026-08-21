module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P2.Bundled
public import PiBaseLean.Properties.P52.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T42: P52 (DiscreteTopology) => P2 (T1Space) -/
theorem instT1SpaceOfDiscreteTopology {X : Type u}
    [TopologicalSpace X] [DiscreteTopology X] :
    T1Space X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T42 : P52 ≤ P2 := fun X _ _ ↦ by
  simp_all only [P52, P2]
  infer_instance

end PiBase.Formal

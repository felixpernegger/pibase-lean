module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P129.Bundled
public import PiBaseLean.Properties.P16.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T251: P129 (IndiscreteTopology) => P16 (CompactSpace) -/
theorem instCompactSpaceOfIndiscreteTopology {X : Type u}
    [TopologicalSpace X] [IndiscreteTopology X] : CompactSpace X := by
  infer_instance

end PiBase

namespace PiBase.Formal

theorem T251 : P129 ≤ P16 := fun X _ _ ↦ by
  simp_all only [P129, P16]
  infer_instance

end PiBase.Formal

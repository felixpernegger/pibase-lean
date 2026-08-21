module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P141.Bundled
public import PiBaseLean.Properties.P79.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T59: P79 (SequentialSpace) => P141 (CompactlyGeneratedSpace) -/
theorem instCompactlyGeneratedSpaceOfSequentialSpace {X : Type u}
    [TopologicalSpace X] [SequentialSpace X] : CompactlyGeneratedSpace X := by
  infer_instance

end PiBase

namespace PiBase.Formal

theorem T59 : P79 ≤ P141 := fun X _ _ ↦ by
  simp_all only [P79, P141]
  infer_instance

end PiBase.Formal

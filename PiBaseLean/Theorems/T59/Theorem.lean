module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P79.Defs
public import PiBaseLean.Properties.P141.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T59: P79 (SequentialSpace) => P141 (CompactlyGeneratedSpace) -/
theorem instCompactlyGeneratedSpaceOfSequentialSpace (X : Type u)
    [TopologicalSpace X] [SequentialSpace X] : CompactlyGeneratedSpace X := by
  infer_instance

end PiBase

namespace PiBase.Formal

theorem T59 : P79 ≤ P141 := fun X _ _ ↦ by
  simp_all only [P79, P141]
  infer_instance

end PiBase.Formal

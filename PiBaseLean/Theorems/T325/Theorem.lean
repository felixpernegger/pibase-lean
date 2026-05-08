module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P140.Defs
public import PiBaseLean.Properties.P141.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T325: P141 (CompactlyGeneratedSpace) => P140 (CompactlyCoherentSpace) -/
theorem instCompactlyCoherentSpaceOfCompactlyGeneratedSpace (X : Type u)
    [TopologicalSpace X] [CompactlyGeneratedSpace X] : CompactlyCoherentSpace X := by
  infer_instance

end PiBase

namespace PiBase.Formal

theorem T325 : P141 ≤ P140 := fun X _ _ ↦ by
  simp_all only [P141, P140]
  infer_instance

end PiBase.Formal

module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P26.Defs
public import PiBaseLean.Properties.P55.Defs
public import PiBaseLean.Properties.P116.Defs

@[expose] public section

universe u

open Topology Set Function TopologicalSpace

namespace PiBase

/-- Theorem T201: P26 (SeparableSpace) + P55 (IsCompletelyMetrizableSpace) => P116 (PolishSpace) -/
theorem instPolishSpaceOfSeparableSpaceOfIsCompletelyMetrizableSpace (X : Type u)
    [TopologicalSpace X] [SeparableSpace X] [IsCompletelyMetrizableSpace X] :
    PolishSpace X := by tauto

end PiBase

namespace PiBase.Formal

theorem T201 : P26 ⊓ P55 ≤ P116 :=
    fun X _ ↦ and_imp.2 (@instPolishSpaceOfSeparableSpaceOfIsCompletelyMetrizableSpace X _)

end PiBase.Formal

module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P102.Defs
public import PiBaseLean.Properties.P104.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T624: P102 (SemimetrizableSpace) => P104 (SymmetrizableSpace) -/
instance instSymmetrizableSpaceOfSemimetrizableSpace (X : Type u)
    [TopologicalSpace X] [h : SemimetrizableSpace X] :
    SymmetrizableSpace X where
  nonempty_symmetric := .intro h.nonempty_semimetric.some.symmetricSpace

end PiBase

namespace PiBase.Formal

theorem T624 : P102 ≤ P104 := fun X _ ↦ @instSymmetrizableSpaceOfSemimetrizableSpace X _

end PiBase.Formal

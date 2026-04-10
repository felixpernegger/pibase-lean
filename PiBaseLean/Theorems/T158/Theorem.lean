module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P32.Defs
public import PiBaseLean.Properties.P127.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T158: P127 (DowkerSpace) => P32 (¬CountablyParacompactSpace) -/
theorem instNotCountablyParacompactSpaceOfDowkerSpace (X : Type u)
    [TopologicalSpace X] [DowkerSpace X] :
    ¬ CountablyParacompactSpace X := by exact DowkerSpace.not_countably_paracompact

end PiBase

namespace PiBase.Formal

theorem T158 : P127 ≤ P32ᶜ := fun X _ h ↦
  @instNotCountablyParacompactSpaceOfDowkerSpace X _ h

end PiBase.Formal

module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P127.Bundled
public import PiBaseLean.Properties.P32.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T158: P127 (DowkerSpace) => P32 (¬CountablyParacompactSpace) -/
theorem instNotCountablyParacompactSpaceOfDowkerSpace {X : Type u}
    [TopologicalSpace X] [DowkerSpace X] :
    ¬ CountablyParacompactSpace X := by exact DowkerSpace.not_countably_paracompact

end PiBase

namespace PiBase.Formal

theorem T158 : P127 ≤ P32ᶜ := fun X _ h ↦
  @instNotCountablyParacompactSpaceOfDowkerSpace X _ h

end PiBase.Formal

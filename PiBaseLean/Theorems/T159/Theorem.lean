module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P7.Defs
public import PiBaseLean.Properties.P32.Defs
public import PiBaseLean.Properties.P127.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T159: P7 (T4Space) + P32 (¬CountablyParacompactSpace) => P127 (DowkerSpace) -/
theorem instDowkerSpaceOfT4SpaceOfNotCountablyParacompactSpace (X : Type u)
    [TopologicalSpace X] [T4Space X] (h2 : ¬ CountablyParacompactSpace X) :
    DowkerSpace X := by tauto

end PiBase

namespace PiBase.Formal

theorem T159 : P7 ⊓ P32ᶜ ≤ P127 := fun X _ ⟨h1, h2⟩ ↦
  @instDowkerSpaceOfT4SpaceOfNotCountablyParacompactSpace X _ h1 h2

end PiBase.Formal

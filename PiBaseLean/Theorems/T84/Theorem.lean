module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P5.Defs
public import PiBaseLean.Properties.P177.Defs

@[expose] public section

universe u

open Topology TopologicalSpace

namespace PiBase

/-- Theorem T84: P177 (SigmaSpace) => P5 (T3Space) -/
theorem instT3SpaceOfSigmaSpace (X : Type u)
    [TopologicalSpace X] [SigmaSpace X] :
    T3Space X := instT3Space

end PiBase

namespace PiBase.Formal

theorem T84 : P177 ≤ P5 := fun X _ ↦ @instT3SpaceOfSigmaSpace X _

end PiBase.Formal

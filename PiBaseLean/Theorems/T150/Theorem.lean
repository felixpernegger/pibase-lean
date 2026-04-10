module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P5.Defs
public import PiBaseLean.Properties.P117.Defs
public import PiBaseLean.Properties.P177.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T150: P117 (HasSigmaLocallyFiniteNetwork) + P5 (T3Space) => P177 (SigmaSpace) -/
theorem instSigmaSpaceOfHasSigmaLocallyFiniteNetworkOfT3Space (X : Type u)
    [TopologicalSpace X] [HasSigmaLocallyFiniteNetwork X] [T3Space X] :
    SigmaSpace X := by tauto

end PiBase

namespace PiBase.Formal

theorem T150 : P117 ⊓ P5 ≤ P177 := fun X _ ↦ and_imp.2 (@instSigmaSpaceOfHasSigmaLocallyFiniteNetworkOfT3Space X _)

end PiBase.Formal

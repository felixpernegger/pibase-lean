module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P5.Defs
public import PiBaseLean.Properties.P118.Defs
public import PiBaseLean.Properties.P178.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T197: P118 (HasSigmaLocallyFiniteKNetwork) + P5 (T3Space) => P178 (AlephSpace) -/
theorem instAlephSpaceOfHasSigmaLocallyFiniteKNetworkOfT3Space (X : Type u)
    [TopologicalSpace X] [HasSigmaLocallyFiniteKNetwork X] [T3Space X] :
    AlephSpace X := by tauto

end PiBase

namespace PiBase.Formal

theorem T197 : P118 ⊓ P5 ≤ P178 := fun X _ ↦ and_imp.2 (@instAlephSpaceOfHasSigmaLocallyFiniteKNetworkOfT3Space X _)

end PiBase.Formal

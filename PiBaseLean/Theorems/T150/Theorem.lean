module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P117.Bundled
public import PiBaseLean.Properties.P177.Bundled
public import PiBaseLean.Properties.P5.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T150: P117 (HasSigmaLocallyFiniteNetwork) + P5 (T3Space) => P177 (SigmaSpace) -/
theorem instSigmaSpaceOfHasSigmaLocallyFiniteNetworkOfT3Space {X : Type u}
    [TopologicalSpace X] [HasSigmaLocallyFiniteNetwork X] [T3Space X] :
    SigmaSpace X := by tauto

end PiBase

namespace PiBase.Formal

theorem T150 : P117 ⊓ P5 ≤ P177 :=
  fun X _ ↦ and_imp.2 (@instSigmaSpaceOfHasSigmaLocallyFiniteNetworkOfT3Space X _)

end PiBase.Formal

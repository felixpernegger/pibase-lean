module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P117.Bundled
public import PiBaseLean.Properties.P177.Bundled

@[expose] public section

universe u

namespace PiBase

-- Most likely redundant
/-- Theorem T147: P177 (SigmaSpace) => P117 (HasSigmaLocallyFiniteNetwork) -/
theorem instHasSigmaLocallyFiniteNetworkOfSigmaSpace {X : Type u}
    [TopologicalSpace X] [SigmaSpace X] :
    HasSigmaLocallyFiniteNetwork X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T147 : P177 ≤ P117 := fun X _ ↦ @instHasSigmaLocallyFiniteNetworkOfSigmaSpace X _

end PiBase.Formal

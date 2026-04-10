module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P117.Defs
public import PiBaseLean.Properties.P177.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

-- Most likely redundant
/-- Theorem T147: P177 (SigmaSpace) => P117 (HasSigmaLocallyFiniteNetwork) -/
theorem instHasSigmaLocallyFiniteNetworkOfSigmaSpace (X : Type u)
    [TopologicalSpace X] [SigmaSpace X] :
    HasSigmaLocallyFiniteNetwork X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T147 : P177 ≤ P117 := fun X _ ↦ @instHasSigmaLocallyFiniteNetworkOfSigmaSpace X _

end PiBase.Formal

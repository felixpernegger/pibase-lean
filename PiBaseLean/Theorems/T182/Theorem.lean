module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P118.Defs
public import PiBaseLean.Properties.P178.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T182: P178 (AlephSpace) => P118 (HasSigmaLocallyFiniteKNetwork) -/
theorem instHasSigmaLocallyFiniteKNetworkOfAlephSpace (X : Type u)
    [TopologicalSpace X] [AlephSpace X] :
    HasSigmaLocallyFiniteKNetwork X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T182 : P178 ≤ P118 := fun X _ ↦ @instHasSigmaLocallyFiniteKNetworkOfAlephSpace X _

end PiBase.Formal

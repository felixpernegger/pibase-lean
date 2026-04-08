module

public import PiBaseLean.Properties.P118.Defs
public import Mathlib.Topology.Separation.Regular

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 178. ℵ-space -/
class AlephSpace (X : Type u) [TopologicalSpace X] : Prop extends
    T3Space X, HasSigmaLocallyFiniteKNetwork X

end PiBase

namespace PiBase.Formal

def P178 : Property where
  toPred := AlephSpace
  well_defined φ h := sorry

end PiBase.Formal

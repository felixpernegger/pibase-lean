module

public import Mathlib.Topology.Homeomorph.Lemmas
public import PiBaseLean.Properties.P36.Defs

@[expose] public section

namespace PiBase

/- 188. Continuum -/
class ContinuumSpace (X : Type*) [TopologicalSpace X] : Prop
    extends PreconnectedSpace X, CompactSpace X, T2Space X

end PiBase

namespace PiBase.Formal

def P188 : Property where
  toPred := ContinuumSpace
  well_defined φ h := @ContinuumSpace.mk _ _ (P36.well_defined φ h.toPreconnectedSpace)
    φ.compactSpace φ.t2Space

end PiBase.Formal

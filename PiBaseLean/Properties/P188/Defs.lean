module

public import PiBaseLean.Properties.P36.Defs

@[expose] public section

namespace PiBase

/- 188. Continuum -/
class ContinuumSpace (X : Type*) [TopologicalSpace X] : Prop
    extends PreconnectedSpace X, CompactSpace X, T2Space X

end PiBase

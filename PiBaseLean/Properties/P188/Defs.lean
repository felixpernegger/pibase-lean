import Mathlib

namespace PiBase

/- 188. Continuum -/
class ContinuumSpace (X : Type*) [TopologicalSpace X] : Prop
    extends PreconnectedSpace X, CompactSpace X, T2Space X

end PiBase

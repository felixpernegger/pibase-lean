module

public import Mathlib.Topology.CWComplex.Classical.Basic

@[expose] public section

universe u

namespace PiBase

/- 240. CW complex -/
class CWComplexSpace (X : Type u) [TopologicalSpace X] : Prop where
  cell_structure : Nonempty (Topology.CWComplex (@Set.univ X))

end PiBase

module

public import Mathlib.Topology.CWComplex.Classical.Basic
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

universe u

namespace PiBase

/- 240. CW complex -/
class CWComplexSpace (X : Type u) [TopologicalSpace X] : Prop where
  cell_structure : Nonempty (Topology.CWComplex (@Set.univ X))

end PiBase

namespace PiBase.Formal

def P240 : Property where
  toPred := CWComplexSpace
  well_defined φ h := sorry

end PiBase.Formal

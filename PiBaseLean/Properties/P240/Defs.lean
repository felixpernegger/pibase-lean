module

public import Mathlib.Topology.CWComplex.Classical.Basic
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Set

namespace PiBase

/- 240. CW complex -/
class IsCWComplex (X : Type*) [TopologicalSpace X] : Prop extends T2Space X where
  isComplex : Nonempty (CWComplex (univ (α := X)))

end PiBase

namespace PiBase.Formal

def P240 : Property where
  toPred := IsCWComplex
  well_defined φ h := sorry

end PiBase.Formal

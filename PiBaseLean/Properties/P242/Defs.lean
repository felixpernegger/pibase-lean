module

public import Mathlib.Topology.Homotopy.HomotopyGroup
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

universe u

namespace PiBase

/- 242. Weakly contractible -/
class WeaklyContractibleSpace (X : Type u) [TopologicalSpace X] : Prop where
  homotopically_trivial (x : X) (N : Type) : Subsingleton (HomotopyGroup N X x)

end PiBase

namespace PiBase.Formal

def P242 : Property where
  toPred := WeaklyContractibleSpace
  well_defined φ h := sorry

end PiBase.Formal

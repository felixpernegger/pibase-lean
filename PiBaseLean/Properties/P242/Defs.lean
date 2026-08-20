module

public import Mathlib.Topology.Homotopy.HomotopyGroup

@[expose] public section

universe u

namespace PiBase

/- 242. Weakly contractible -/
class WeaklyContractibleSpace (X : Type u) [TopologicalSpace X] : Prop where
  nonempty : Nonempty X
  homotopically_trivial (x : X) (N : Type) : Finite N → Subsingleton (HomotopyGroup N X x)

end PiBase

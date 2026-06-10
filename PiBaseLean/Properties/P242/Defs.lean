module

public import Mathlib.Topology.Connected.PathConnected
public import Mathlib.Topology.Homotopy.HomotopyGroup
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

namespace PiBase

/- 242. Weakly contractible space -/
class WeaklyContractibleSpace (X : Type*) [TopologicalSpace X] :
    Prop extends PathConnectedSpace X where
  homotopyGroup_trivial (n : ℕ) (x : X) : Nonempty (HomotopyGroup (Fin (n + 1)) X x ≃ Unit)

end PiBase

namespace PiBase.Formal

def P242 : Property where
  toPred := WeaklyContractibleSpace
  well_defined φ h := sorry

end PiBase.Formal

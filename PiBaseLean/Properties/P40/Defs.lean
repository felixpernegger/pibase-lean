module

public import Mathlib.Topology.Defs.Basic
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

namespace PiBase

/- 40. Ultraconnected -/
class UltraconnectedSpace (X : Type*) [TopologicalSpace X] : Prop where
  ultraconnected : ∀ s v : Set X, IsClosed s → IsClosed v →
    s.Nonempty → v.Nonempty → (s ∩ v).Nonempty

end PiBase

namespace PiBase.Formal

def P40 : Property where
  toPred := UltraconnectedSpace
  well_defined φ h := sorry

end PiBase.Formal

import Mathlib.Topology.Defs.Basic

namespace PiBase

/- 40. Ultraconnected -/
class UltraconnectedSpace (X : Type*) [TopologicalSpace X] : Prop where
  ultraconnected : ∀ s v : Set X, IsClosed s → IsClosed v →
    s.Nonempty → v.Nonempty → (s ∩ v).Nonempty

end PiBase

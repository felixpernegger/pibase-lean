module

public import Mathlib.Topology.GDelta.Basic

@[expose] public section

universe u

namespace PiBase

/- 147. P-space -/
class PSpace (X : Type u) [TopologicalSpace X] : Prop where
  isGδ_open : ∀ ⦃s : Set X⦄, IsGδ s → IsOpen s

end PiBase

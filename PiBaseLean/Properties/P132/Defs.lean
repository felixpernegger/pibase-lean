module

public import Mathlib.Topology.GDelta.Basic

@[expose] public section

universe u

namespace PiBase

/- 132. Gδ space -/
class GδSpace (X : Type u) [TopologicalSpace X] : Prop where
  closed_gdelta : ∀ ⦃s : Set X⦄, IsClosed s → IsGδ s

end PiBase

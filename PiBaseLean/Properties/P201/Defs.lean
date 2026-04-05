import Mathlib.Topology.Defs.Filter

open Set Topology Filter


universe u

namespace PiBase

/-- 201. Has a generic point -/
class HasGenericPoint (X : Type u) [TopologicalSpace X] : Prop where
  ex_generic_point : ∃ p : X, ∀ ⦃s : Set X⦄, IsOpen s → p ∈ s

end PiBase

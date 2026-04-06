import Mathlib.Topology.Sober

open Set Topology Filter


universe u

namespace PiBase

/-- 201. Has a generic point -/
class HasGenericPoint (X : Type u) [TopologicalSpace X] : Prop where
  ex_generic_point : ∃ p : X, IsGenericPoint p Set.univ

end PiBase

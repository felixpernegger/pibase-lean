module

public import Mathlib.Topology.Sober

@[expose] public section

open Set Topology Filter

namespace PiBase

/-- 201. Has a generic point -/
class HasGenericPoint (X : Type*) [TopologicalSpace X] : Prop where
  ex_generic_point : ∃ p : X, IsGenericPoint p Set.univ

end PiBase

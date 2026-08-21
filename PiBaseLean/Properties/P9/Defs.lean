module

public import Mathlib.Topology.UnitInterval

@[expose] public section

open unitInterval
namespace PiBase

/- 9. Functionally Hausdorff -/
class FunctionallyT2Space (X : Type*) [TopologicalSpace X] : Prop where
  functionally_t2 : Pairwise fun x y : X ↦ ∃ f : C(X, I), f x = 0 ∧ f y = 1

end PiBase

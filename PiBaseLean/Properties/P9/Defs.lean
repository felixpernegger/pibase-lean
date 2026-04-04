import Mathlib.Topology.MetricSpace.Pseudo.Defs

open Topology Set Function
namespace PiBase

/- 9. Functionally Hausdorff -/
class CompletelyT2Space (X : Type*) [TopologicalSpace X] : Prop where
  completelyT2 : Pairwise fun x y : X ↦ ∃ f : X → ℝ, Continuous f ∧ f x = 0 ∧ f y = 1

end PiBase

namespace PiBase.Formal

abbrev P9 := CompletelyT2Space

class NP9 (X : Type*) [TopologicalSpace X] where
  not_p9 : ¬ P9 X

end PiBase.Formal

import Mathlib.Topology.Defs.Basic

open Topology Set Function TopologicalSpace

namespace PiBase

/- 89. Fixed point property -/
class FixedPointSpace (X : Type*) [TopologicalSpace X] : Prop where
  fixed_point : ∀ (f : X → X), Continuous f → ∃ x : X, f x = x

end PiBase

namespace PiBase.Formal

abbrev P89 := FixedPointSpace

class NP89 (X : Type*) [TopologicalSpace X] where
  not_p89 : ¬ P89 X

end PiBase.Formal

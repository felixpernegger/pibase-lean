import Mathlib.Topology.Homeomorph.Defs

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 86. Homogenous -/
class HomogenousSpace (X : Type*) [TopologicalSpace X] : Prop where
  homogenous : ∀ (x y : X), ∃ f : X ≃ₜ X, f x = y

end PiBase

namespace PiBase.Formal

abbrev P86 := HomogenousSpace

class NP86 (X : Type*) [TopologicalSpace X] where
  not_p86 : ¬ P86 X

end PiBase.Formal

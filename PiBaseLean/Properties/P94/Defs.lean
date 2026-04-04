import Mathlib.Data.Finite.Defs
import Mathlib.Topology.Defs.Filter

open Topology Filter

namespace PiBase

/- 94. Locally finite -/
class LocallyFiniteSpace (X : Type*) [TopologicalSpace X] : Prop where
  locally_finite : ∀ x : X, ∃ s ∈ 𝓝 x, s.Finite

end PiBase

namespace PiBase.Formal

abbrev P94 := LocallyFiniteSpace

class NP94 (X : Type*) [TopologicalSpace X] where
  not_p94 : ¬ P94 X

end PiBase.Formal

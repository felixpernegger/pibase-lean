import Mathlib.Data.Set.Countable
import Mathlib.Topology.Defs.Filter

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 93. Locally countable -/
class LocallyCountableSpace (X : Type*) [TopologicalSpace X] : Prop where
  locally_countable : ∀ x : X, ∃ s ∈ 𝓝 x, s.Countable

end PiBase

namespace PiBase.Formal

abbrev P93 := LocallyCountableSpace

class NP93 (X : Type*) [TopologicalSpace X] where
  not_p93 : ¬ P93 X

end PiBase.Formal

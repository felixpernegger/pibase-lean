import Mathlib.Topology.Defs.Filter

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 100. KC Space -/
class KcSpace (X : Type*) [TopologicalSpace X] : Prop where
  kc : ∀ s : Set X, IsCompact s → IsClosed s

end PiBase

namespace PiBase.Formal

abbrev P100 := KcSpace

class NP100 (X : Type*) [TopologicalSpace X] where
  not_p100 : ¬ P100 X

end PiBase.Formal

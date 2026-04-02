import Mathlib.Topology.Defs.Filter

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 100. KC Space -/
class KcSpace (X : Type*) [TopologicalSpace X] : Prop where
  kc : ∀ s : Set X, IsCompact s → IsClosed s

end PiBase

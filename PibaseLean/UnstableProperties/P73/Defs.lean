import Mathlib

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 73. Sober -/
class SoberSpace (X : Type*) [TopologicalSpace X] : Prop where
  sober : ∀ {S : Set X}, IsIrreducible S → IsClosed S → ∃! x, IsGenericPoint x S

end PiBase

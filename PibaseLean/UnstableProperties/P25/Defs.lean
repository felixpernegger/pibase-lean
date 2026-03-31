import Mathlib

open Function Set Filter Topology TopologicalSpace Set.Notation

namespace UnstablePiBase

/- 25. Exhaustlible by compacts -/
class ExhaustibleByCompacts (X : Type*) [TopologicalSpace X] : Prop where
  exhaustion : Nonempty (CompactExhaustion X)

end UnstablePiBase

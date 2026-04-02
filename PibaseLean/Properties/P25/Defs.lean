import Mathlib.Topology.Compactness.SigmaCompact

open Function Set Filter Topology TopologicalSpace

namespace PiBase

/- 25. Exhaustlible by compacts -/
class ExhaustibleByCompacts (X : Type*) [TopologicalSpace X] : Prop where
  exhaustion : Nonempty (CompactExhaustion X)

end PiBase

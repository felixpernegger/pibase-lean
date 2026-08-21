module

public import Mathlib.Topology.Compactness.SigmaCompact

@[expose] public section

namespace PiBase

/- 25. Exhaustlible by compacts -/
class ExhaustibleByCompacts (X : Type*) [TopologicalSpace X] : Prop where
  exhaustion : Nonempty (CompactExhaustion X)

end PiBase

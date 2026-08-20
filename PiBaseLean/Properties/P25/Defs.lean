module

public import Mathlib.Topology.Compactness.SigmaCompact
public import Mathlib.Topology.Homeomorph.Defs

@[expose] public section

open Function Set Filter Topology TopologicalSpace

namespace PiBase

/- 25. Exhaustlible by compacts -/
class ExhaustibleByCompacts (X : Type*) [TopologicalSpace X] : Prop where
  exhaustion : Nonempty (CompactExhaustion X)

end PiBase

import Mathlib.Topology.Compactness.SigmaCompact
import PiBaseLean.Properties.Bundled.Defs

open Function Set Filter Topology TopologicalSpace

namespace PiBase

/- 25. Exhaustlible by compacts -/
class ExhaustibleByCompacts (X : Type*) [TopologicalSpace X] : Prop where
  exhaustion : Nonempty (CompactExhaustion X)

end PiBase

namespace PiBase.Formal

def P25 : Property where
  toPred := ExhaustibleByCompacts
  well_defined φ h := sorry

end PiBase.Formal

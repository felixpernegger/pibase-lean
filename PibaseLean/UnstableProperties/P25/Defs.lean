import Mathlib
import PibaseLean.Properties.P37

open Function Set Filter Topology TopologicalSpace Set.Notation


namespace PiBase

/- 25. Exhaustlible by compacts -/
class ExhaustibleByCompacts (X : Type*) [TopologicalSpace X] : Prop
  extends SigmaCompactSpace X, WeaklyLocallyCompact X

end PiBase

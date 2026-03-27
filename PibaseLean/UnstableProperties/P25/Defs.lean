import Mathlib
import PibaseLean.UnstableProperties.P37.Defs

open Function Set Filter Topology TopologicalSpace Set.Notation


namespace UnstablePiBase

/- 25. Exhaustlible by compacts -/
class ExhaustibleByCompacts (X : Type*) [TopologicalSpace X] : Prop
  extends SigmaCompactSpace X, WeaklyLocallyCompactSpace X

end UnstablePiBase

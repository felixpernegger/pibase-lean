import PiBaseLean.Properties.P110.Defs

open Topology Set

universe u

namespace PiBase

/- 113. Moore Space -/
class MooreSpace (X : Type u) [TopologicalSpace X] extends DevelopableSpace X, T3Space X

end PiBase

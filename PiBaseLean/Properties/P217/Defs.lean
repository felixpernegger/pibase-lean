import PiBaseLean.AdditionalDefs

open Topology Set Filter Function PiBase.AdditionalDefs

universe u

namespace PiBase

/- 217. Strongly zero dimensional space -/
class StronglyZeroDimensionalSpace (X : Type u) [TopologicalSpace X] : Prop where
  disjoint_clopen (s t : Set X) :

end PiBase

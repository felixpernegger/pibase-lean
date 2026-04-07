import Mathlib.Topology.Compactness.Paracompact
import PiBaseLean.Properties.Bundled.Defs

open Topology Set Filter Function

namespace PiBase

/- 216. Hereditarily paracompact space -/
class HereditarilyParacompact (X : Type*) [TopologicalSpace X] : Prop where
  subset_paracompact (s : Set X) : ParacompactSpace s

end PiBase

namespace PiBase.Formal

def P216 : Property where
  toPred := HereditarilyParacompact
  well_defined φ h := sorry

end PiBase.Formal

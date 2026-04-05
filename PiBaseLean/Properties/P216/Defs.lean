import Mathlib.Topology.Compactness.Paracompact

open Topology Set Filter Function

namespace PiBase

/- 216. Hereditarily paracompact space -/
class HereditarilyParacompact (X : Type*) [TopologicalSpace X] : Prop where
  subset_paracompact (s : Set X) : ParacompactSpace s

end PiBase

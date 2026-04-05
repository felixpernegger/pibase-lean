import Mathlib.Topology.Compactness.Paracompact

open Topology Set Filter Function

universe u

namespace PiBase

/- 216. Hereditarily paracompact space -/
class HereditarilyParacompact (X : Type u) [TopologicalSpace X] : Prop where
  subset_paracompact (s : Set X) : ParacompactSpace s

end PiBase

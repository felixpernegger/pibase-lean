module

public import Mathlib.Topology.Compactness.Paracompact
public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P30.Bundled

@[expose] public section

open Topology Set Filter Function

namespace PiBase

/- 216. Hereditarily paracompact space -/
class HereditarilyParacompact (X : Type*) [TopologicalSpace X] : Prop where
  subset_paracompact : Hereditarily ParacompactSpace X

end PiBase

module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P30.Defs

@[expose] public section

namespace PiBase

/- 216. Hereditarily paracompact space -/
class HereditarilyParacompact (X : Type*) [TopologicalSpace X] : Prop where
  subset_paracompact : Hereditarily ParacompactSpace X

end PiBase

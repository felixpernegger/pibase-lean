module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P162.Defs

@[expose] public section

universe u

namespace PiBase

/- 215. Hereditarily realcompact -/
class HereditarilyRealcompactSpace (X : Type u) [TopologicalSpace X] : Prop where
  subset_realcompact : Hereditarily RealcompactSpace X

end PiBase

module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P162.Defs
public import PiBaseLean.Properties.P162.Bundled

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 215. Hereditarily realcompact -/
class HereditarilyRealcompactSpace (X : Type u) [TopologicalSpace X] : Prop where
  subset_realcompact : Hereditarily RealcompactSpace X

end PiBase

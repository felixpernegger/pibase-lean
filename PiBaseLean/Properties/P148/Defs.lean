module

public import PiBaseLean.Properties.P141.Defs
public import PiBaseLean.Properties.P143.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 148. CWGH -/
class CWGH (X : Type u) [TopologicalSpace X] : Prop extends CompactlyGeneratedSpace X, WeakT2Space X

end PiBase

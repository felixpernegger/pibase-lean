module

public import Mathlib.Topology.Separation.Regular
public import PiBaseLean.Properties.P32.Defs

@[expose] public section

universe u

namespace PiBase

/- 127. Dowker -/
class DowkerSpace (X : Type u) [TopologicalSpace X] : Prop extends T4Space X where
  not_countably_paracompact : ¬ CountablyParacompactSpace X

end PiBase

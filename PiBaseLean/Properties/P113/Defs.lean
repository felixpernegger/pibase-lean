module

public import Mathlib.Topology.Separation.Regular
public import PiBaseLean.Properties.P110.Defs

@[expose] public section

namespace PiBase

/- 113. Moore Space -/
class MooreSpace (X : Type*) [TopologicalSpace X] extends DevelopableSpace X, T3Space X

end PiBase

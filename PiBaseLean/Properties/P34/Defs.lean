module

public import Mathlib.Topology.Compactness.Paracompact

@[expose] public section

namespace PiBase

/- 34. Fully normal -/
class FullyNormalSpace (X : Type*) [TopologicalSpace X] : Prop
  extends ParacompactSpace X, NormalSpace X

end PiBase

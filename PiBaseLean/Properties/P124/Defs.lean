module

public import PiBaseLean.Properties.P123.Defs
public import PiBaseLean.Properties.P3.Defs

@[expose] public section

universe u

namespace PiBase

/- 124. Topological n-manifold -/
class TopologicalNManifold (X : Type u) [TopologicalSpace X] : Prop extends
  LocallyNEuclideanSpace X, T2Space X, SecondCountableTopology X

end PiBase

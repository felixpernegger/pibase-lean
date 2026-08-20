module

public import Mathlib.Topology.Homeomorph.Lemmas
public import Mathlib.Topology.Separation.Hausdorff
public import PiBaseLean.Properties.P236.Defs

@[expose] public section

universe u

namespace PiBase

open Topology

/- 237. Topological n-manifold with boundary -/
class TopologicalNManifoldWithBoundary (X : Type u) [TopologicalSpace X] extends
  SecondCountableTopology X, T2Space X, LocallyNEuclideanHalfSpace X

end PiBase

module

public import PiBaseLean.Properties.P123.Defs
public import Mathlib.Topology.Separation.Hausdorff
public import Mathlib.Topology.Homeomorph.Lemmas

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 124. Topological n-manifold -/
class TopologicalNManifold (X : Type u) [TopologicalSpace X] : Prop extends
  LocallyNEuclideanSpace X, T2Space X, SecondCountableTopology X

end PiBase

namespace PiBase.Formal

def P124 : Property where
  toPred := TopologicalNManifold
  well_defined φ h := sorry

end PiBase.Formal

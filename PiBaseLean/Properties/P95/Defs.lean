import Mathlib.Topology.Path
import PiBaseLean.Properties.Bundled.Defs

open Topology

namespace PiBase

/- 95. Arc connected -/
class ArcConnectedSpace (X : Type*) [TopologicalSpace X] : Prop where
  joined : Pairwise fun x y : X ↦ ∃ f : Path x y, IsEmbedding f

end PiBase

namespace PiBase.Formal

def P95 : Property where
  toPred := ArcConnectedSpace
  well_defined φ h := sorry

end PiBase.Formal

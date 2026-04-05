import Mathlib.Topology.Compactness.Paracompact
import PiBaseLean.Properties.Bundled.Defs

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 34. Fully normal -/
class FullyNormalSpace (X : Type*) [TopologicalSpace X] : Prop
  extends ParacompactSpace X, NormalSpace X

end PiBase

namespace PiBase.Formal

def P34 : Property where
  toPred := FullyNormalSpace
  well_defined' φ _ := @FullyNormalSpace.mk _ _
    φ.symm.isClosedEmbedding.paracompactSpace φ.normalSpace

end PiBase.Formal

import Mathlib.Topology.Metrizable.Basic
import PiBaseLean.Properties.Bundled.Defs

open TopologicalSpace

namespace PiBase

/- 53. Metrizable -/
#check MetrizableSpace

end PiBase

namespace PiBase.Formal

def P53 : Property where
  toPred := MetrizableSpace
  well_defined φ _ := φ.symm.isEmbedding.metrizableSpace

end PiBase.Formal

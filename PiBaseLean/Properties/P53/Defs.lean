import Mathlib.Topology.Metrizable.Basic

open TopologicalSpace

namespace PiBase

/- 53. Metrizable -/
#check MetrizableSpace

end PiBase

namespace PiBase.Formal

abbrev P53 := TopologicalSpace.MetrizableSpace

class NP53 (X : Type*) [TopologicalSpace X] where
  not_p53 : ¬ P53 X

end PiBase.Formal

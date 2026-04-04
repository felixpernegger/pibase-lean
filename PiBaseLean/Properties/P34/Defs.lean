import Mathlib.Topology.Compactness.Paracompact

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 34. Fully normal -/
class FullyNormalSpace (X : Type*) [TopologicalSpace X] : Prop
  extends ParacompactSpace X, NormalSpace X

end PiBase

namespace PiBase.Formal

abbrev P34 := FullyNormalSpace

class NP34 (X : Type*) [TopologicalSpace X] where
  not_p34 : ¬ P34 X

end PiBase.Formal

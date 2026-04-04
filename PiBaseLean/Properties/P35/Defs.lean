import PiBaseLean.Properties.P34.Defs

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 35. Fully T₄ -/
class FullyT4Space (X : Type*) [TopologicalSpace X] : Prop extends T1Space X, FullyNormalSpace X

end PiBase

namespace PiBase.Formal

abbrev P35 := FullyT4Space

class NP35 (X : Type*) [TopologicalSpace X] where
  not_p35 : ¬ P35 X

end PiBase.Formal

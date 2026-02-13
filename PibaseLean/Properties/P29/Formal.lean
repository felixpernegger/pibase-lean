import PibaseLean.Properties.P29.Defs

open TopologicalSpace

namespace PiBase.Formal

abbrev P29 := CountableChainCondition

class NP29 (X : Type*) [TopologicalSpace X] where
  not_p29 : ¬ P29 X

end PiBase.Formal

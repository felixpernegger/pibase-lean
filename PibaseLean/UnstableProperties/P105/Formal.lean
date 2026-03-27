import PibaseLean.UnstableProperties.P105.Defs

namespace PiBase.Formal

abbrev P105 := ParaLindelofSpace

class NP105 (X : Type*) [TopologicalSpace X] where
  not_p105 : ¬ P105 X

end PiBase.Formal

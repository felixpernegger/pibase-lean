import PibaseLean.UnstableProperties.P100.Defs

namespace PiBase.Formal

abbrev P100 := KcSpace

class NP100 (X : Type*) [TopologicalSpace X] where
  not_p100 : ¬ P100 X

end PiBase.Formal

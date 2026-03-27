import PibaseLean.UnstableProperties.P53.Defs

namespace PiBase.Formal

abbrev P53 := MetrizableSpace

class NP53 (X : Type*) [TopologicalSpace X] where
  not_p53 : ¬ P53 X

end PiBase.Formal

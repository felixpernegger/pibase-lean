import PibaseLean.UnstableProperties.P182.Defs

namespace PiBase.Formal

abbrev P182 := HasCountableNetwork

class NP182 (X : Type*) [TopologicalSpace X] where
  not_p182 : ¬ P182 X

end PiBase.Formal

import PibaseLean.UnstableProperties.P86.Defs

namespace PiBase.Formal

abbrev P86 := HomogenousSpace

class NP86 (X : Type*) [TopologicalSpace X] where
  not_p86 : ¬ P86 X

end PiBase.Formal

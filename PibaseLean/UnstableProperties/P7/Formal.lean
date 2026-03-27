import PibaseLean.Properties.P7.Defs

namespace PiBase.Formal

abbrev P7 := T4Space

class NP7 (X : Type*) [TopologicalSpace X] where
  not_p7 : ¬ P7 X

end PiBase.Formal

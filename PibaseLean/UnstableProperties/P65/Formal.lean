import PibaseLean.Properties.P65.Defs

namespace PiBase.Formal

abbrev P65 := CardEqContinuum

class NP65 (X : Type*) [TopologicalSpace X] where
  not_p65 : ¬ P65 X

end PiBase.Formal

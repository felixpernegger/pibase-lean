import PibaseLean.Properties.P15.Defs

namespace PiBase.Formal

abbrev P15 := PerfectlyNormalSpace

class NP15 (X : Type*) [TopologicalSpace X] where
  not_p15 : ¬ P15 X

end PiBase.Formal

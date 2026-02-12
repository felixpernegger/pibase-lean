import PibaseLean.Properties.P18.Defs

namespace PiBase.Formal

abbrev P18 := LindelofSpace

class NP18 (X : Type*) [TopologicalSpace X] where
  not_p18 : ¬ P18 X

end PiBase.Formal

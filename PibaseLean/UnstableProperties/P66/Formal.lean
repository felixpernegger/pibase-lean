import PibaseLean.Properties.P66.Defs

namespace PiBase.Formal

abbrev P66 := MengerSpace

class NP66 (X : Type*) [TopologicalSpace X] where
  not_p66 : ¬ P66 X

end PiBase.Formal

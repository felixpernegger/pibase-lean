import PibaseLean.Properties.P10.Defs

namespace PiBase.Formal

abbrev P10 := SemiregularSpace

class NP1 (X : Type*) [TopologicalSpace X] where
  not_p10 : ¬ P10 X

end PiBase.Formal

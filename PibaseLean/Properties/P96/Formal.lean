import PibaseLean.Properties.P96.Defs

namespace PiBase.Formal

abbrev P96 := LocallyArcConnectedSpace

class NP96 (X : Type*) [TopologicalSpace X] where
  not_p96 : ¬ P96 X

end PiBase.Formal
